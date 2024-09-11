execfile('wsadminlib.py')
import sys
import time
import re

fileName = sys.argv[0]
appName = sys.argv[1]
clusterName = sys.argv[2]
date = time.strftime('%c')

enableDebugMessages()

def _cleanupDmgrCache():
    '''
    Clean dmgr cache for deploy
    '''
    from java.lang import String
    import jarray

    fileContent = '<project name="cleanup" default="cleanup"><target name="cleanup"><delete dir="${user.install.root}/temp" /><delete dir="${user.install.root}/wstemp" /></target></project>'
    antAgent = AdminControl.makeObjectName(AdminControl.queryNames('WebSphere:*,type=AntAgent,process=dmgr'))

    str = String(fileContent)
    bytes = str.getBytes()

    AdminControl.invoke_jmx(antAgent, 'putScript', [String('cleanup.xml'),bytes], jarray.array(['java.lang.String', '[B'], String))
    AdminControl.invoke_jmx(antAgent, 'invokeAnt', [jarray.array([], String), String('cleanup.xml'), String('cleanup')], jarray.array(['[Ljava.lang.String;', 'java.lang.String', 'java.lang.String'], String))



def _logerror(message):
    print date, "ERROR", message

def _loginfo(message):
    print date, "INFO", message

def _isApplicationExists(appName):
    '''
    Returns 1 if application with appName exists (on WAS cell) , else returns 0
    '''
    installedApps = []
    installedApps = listApplications()
    for installedApp in installedApps :
        if appName == installedApp :
            _loginfo('Application [%s] found.' % appName)
            return 1
    _loginfo('Application [%s] not found.' % appName)
    return 0

def _startApplication(appName):
    '''
    Start application only if is ready
    '''
    #result = AdminApp.isAppReady(''+app_name+'-edition'+app_edition+'' )
    result = isApplicationReady(''+ appName +'')
    timeWaited = 0
    while (result == "false" and timeWaited < 180) :
        time.sleep(5)
        timeWaited = timeWaited + 5
        #result = AdminApp.isAppReady(''+app_name+'-edition'+app_edition+'' )
        result = isApplicationReady(''+ appName +'')
    if (timeWaited >= 180):
        _logerror('Application [%s] could not be started in time(%s) because it is not ready.' % appName, timeWaited)
        sys.exit(600)
    else:
        _loginfo('Starting application [%s].' % appName)
        startApplicationOnCluster(appName,clusterName)

'''
If application with appName exists then update, else install.
'''
if _isApplicationExists(''+ appName +''):
    # _loginfo('Cleanup dmgr cache...')
    # _cleanupDmgrCache()
    _loginfo('Updating application [%s].' % appName)
    updateApplication(fileName,appName)
else:
    # _loginfo('Cleanup dmgr cache...')
    # _cleanupDmgrCache()
    _loginfo('Installing application [%s].' % appName)
    installApplication( fileName, [] , [''+ clusterName +''] , ['-appname', '' + appName + '', '-usedefaultbindings'] )

'''
Check success cluster install
'''
regex = r"(\([A-z|0-9|/|\-|\.|#]*\))"
clusterCheck = 0
clusterInstalled = getClusterTargetsForApplication(''+ appName +'')
appPath = AdminConfig.getid('/Deployment:'+appName+'')
appModule = AdminConfig.showAttribute(''+ appPath +'','deploymentTargets')
appManageModule = re.findall(regex, appModule)

# CHG0609051 - NIKEDEVSEC-2751 - NIKEDEVSEC-2796
flagClusterIsEmpty = False

print "Details application"
print "Name:" , appName
print "Cluster send: " , clusterName
if not clusterInstalled :
    clusterInstalled.append(clusterName)
    # CHG0609051 - NIKEDEVSEC-2751 - NIKEDEVSEC-2796
    flagClusterIsEmpty = True
    print("List cluster is empty!!")
    print("Using DevSecOps param")
    print "Cluster set: " , clusterInstalled[0]
else :
    print "Cluster read: " , clusterInstalled[0]

while clusterCheck != 3:
    if clusterInstalled[0] != clusterName :
        print "entrei"
        appModule = AdminConfig.showAttribute(''+ appPath +'','deploymentTargets')
        appManageModule = re.findall(regex, appModule)
        _loginfo('Update cluster name for correct')
        print clusterInstalled[0], "error - ", clusterName, "correct change it"
        AdminConfig.modify(appManageModule[0],[[ 'name',clusterName ]])
        clusterInstalled =  getClusterTargetsForApplication(''+ appName +'')
        clusterCheck = clusterCheck + 1
    else :
        clusterCheck = 3
else:
#   CHG0609051 - NIKEDEVSEC-2751 - NIKEDEVSEC-2796
    if flagClusterIsEmpty:
        _loginfo("%s, error - Forcing cluster name passed by devsecops parameter" %  clusterInstalled[0])
        cellName = AdminControl.getCell()
        target = "WebSphere:cell=%s,cluster=%s" % (cellName, clusterInstalled[0])
        AdminApp.edit(appName, '[-MapModulesToServers [[.* .* %s]]]' % target)
#       NameModule="'.*'"
#       URI="'.*'"
#       target="WebSphere:cell=" + cellName + ",cluster=" + clusterName
#       AdminApp.edit(AppName, '[-MapModulesToServers [['+NameModule+' '+URI+' '+target+']]]')
    if clusterInstalled[0] == clusterName :
        _loginfo('Cluster name OK!')
        print "Cluster", clusterName , " for application ", appName , " it's Ok"
    else :
        _logerror('Cluster name ERROR!')
        print "Not possible change cluster", clusterName , " for application ", appName
        sys.exit(601)

'''
Save config changes and sync them - return 0 on sync success, non-zero on failures
'''
if saveAndSync():
    _logerror('Could not finish sync.')
    sys.exit(601)
else:
    _loginfo('Sync completed!')

'''
Starts application if necessary
'''
if isApplicationRunning(appName):
   _loginfo('Application [%s] is already started.' % appName)
else:
   _startApplication(appName)

# Layout map log

``` groovy
log = [ launch : "",
        description : "",
        type : "",
        id_execution : "",
        url_execution: "",
        debug : "",
        itil_process : [ change_order : "" , request : "" ],
        parameters:[ example : "null", ],
        execution_result : "",
        message : "",
        who_executed : "",
        date_start : "",
        date_end : "",
        joaquinx_environment : "" ,
        running_in : "" ]
```

# Json log 

``` json
{
    "launch": "launch-example",
    "description": "Este job \u00e9 apenas para testes do time devsecops-paas",
    "type": "normal",
    "id_execution": 1174,
    "url_execution": "http://spobrcatalog:8080/job/Joaquin-X.Rpa.vmware-ad-clean/1/console",
    "debug": true,
    "itil_process": {
        "change_order": "",
        "request": ""
    },
    "parameters": {
        "u_sprint1": "sdds",
        "senha": "password",
        "category": "Openshift",
        "u_token_fake": "chosen vault usr-baleia"
    },
    "execution_result": "SUCCESS",
    "message": "Success launch of the tools-test by sof5305",
    "who_executed": "sof5305",
    "date_start": "2021-07-14 11:28:31",
    "date_end": "2021-07-14 11:28:52",
    "joaquinx_environment": "homolog",
    "running_in": "onpremises"
}
```

# Table BI

``` sql
CREATE TABLE JOAQUINX_BI (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  launch varchar(300) not null ,
  type varchar(30) not null ,
  date_start datetime not null ,
  date_end datetime not null ,
  execution_result varchar(10) not null,
  who_executed varchar(10) not null,
  joaquinx_environment varchar(30) not null ,
  log json ,
  PRIMARY KEY (id)
) ENGINE=InnoDB;
```
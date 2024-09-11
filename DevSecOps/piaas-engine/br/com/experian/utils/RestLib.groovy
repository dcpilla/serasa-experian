import java.net.URL
import java.io.*
import jenkins.util.*
import jenkins.model.*
import static groovy.io.FileType.FILES
import java.text.SimpleDateFormat
import java.nio.charset.StandardCharsets

/**
 * httpPost
 * Método realiza o POST de payload para a URI especificada
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 **/
def httpPost(def uri, def user, def pass, def successResponseCode, def payload, def successMessage, def failMessage) {

    HttpURLConnection conn = null
    BufferedReader reader = null
    def responseCode
    def responseMessage
    def authorization = ""

    try {     
        conn = new URL(uri).openConnection() as HttpURLConnection
        conn.setDoOutput(true)
        conn.setRequestMethod("POST")
        conn.setRequestProperty("Content-Type", "application/json")
        conn.setRequestProperty("charset", "utf-8")
        conn.setRequestProperty("Content-Length", String.valueOf(payload.length()))
        conn.setRequestProperty("Authorization", "Basic " + "${user}:${pass}".bytes.encodeBase64().toString())
        conn.setUseCaches(false)
        conn.setConnectTimeout(5000)
        def os = conn.getOutputStream()
        os.write(payload.getBytes("utf-8"))
        os.flush()
        os.close()
        responseCode = conn.getResponseCode()
        responseMessage = conn.getResponseMessage()
        InputStream inputStream
        if (responseCode == successResponseCode) {
            inputStream = conn.getInputStream()
        } else {
            inputStream = conn.getErrorStream()
        }
        reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))
        StringBuilder response = new StringBuilder()
        String line
        while ((line = reader.readLine()) != null) {
            response.append(line)
        }
        if (responseCode == successResponseCode) {
            println "Success in POST ${successMessage}!"
            return response.toString()
        } else {
            println "Failed in POST ${failMessage} - Return code: ${responseCode} - Error message: ${responseMessage}"
            return null
        }
    } catch (SocketTimeoutException ste) {
        println "Connection timeout!"
        return null
    } catch (Exception e) {
        println "Failed in POST ${failMessage} - Return code: ${responseCode} - Error message: ${responseMessage}"
        return null
    } finally {
        if (reader != null) {
            try {
                reader.close()
            } catch (IOException e) {
            }
        }
        if (conn != null) {
            try {
                conn.inputStream.close()
            } catch (Exception e) {
            }
            conn.disconnect()
        }
    }
}

/**
 * httpPostBearer
 * Método realiza o POST de payload para a URI especificada com autenticação Bearer
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 **/
def httpPostBearer(def uri, def pass, def successResponseCode, def payload, def successMessage, def failMessage) {

    HttpURLConnection conn = null
    BufferedReader reader = null
    def responseCode
    def responseMessage
    def authorization = ""

    try {     
        conn = new URL(uri).openConnection() as HttpURLConnection
        conn.setDoOutput(true)
        conn.setRequestMethod("POST")
        conn.setRequestProperty("Content-Type", "application/json")
        conn.setRequestProperty("charset", "utf-8")
        conn.setRequestProperty("Content-Length", String.valueOf(payload.length()))
        conn.setRequestProperty("Authorization", "Bearer " + "${pass}")
        conn.setUseCaches(false)
        conn.setConnectTimeout(5000)
        def os = conn.getOutputStream()
        os.write(payload.getBytes("utf-8"))
        os.flush()
        os.close()
        responseCode = conn.getResponseCode()
        responseMessage = conn.getResponseMessage()
        InputStream inputStream
        if (responseCode == successResponseCode) {
            inputStream = conn.getInputStream()
        } else {
            inputStream = conn.getErrorStream()
        }
        reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))
        StringBuilder response = new StringBuilder()
        String line
        while ((line = reader.readLine()) != null) {
            response.append(line)
        }
        if (responseCode == successResponseCode) {
            println "Success in POST ${successMessage}!"
            return response.toString()
        } else {
            println "Failed in POST ${failMessage} - Return code: ${responseCode} - Error message: ${responseMessage}"
            return null
        }
    } catch (SocketTimeoutException ste) {
        println "Connection timeout!"
        return null
    } catch (Exception e) {
        println "Failed in POST ${failMessage} - Return code: ${responseCode} - Error message: ${responseMessage}"
        return null
    } finally {
        if (reader != null) {
            try {
                reader.close()
            } catch (IOException e) {
            }
        }
        if (conn != null) {
            try {
                conn.inputStream.close()
            } catch (Exception e) {
            }
            conn.disconnect()
        }
    }
}

/**
 * httpPostPA
 * Método realiza o POST de payload para URI do Power Automate
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@experian.com>
 **/
def httpPostPA(def uri, def payload) {

    def maxAttempts = 3
    def success = false

    for (int attempt = 1; attempt <= maxAttempts && !success; attempt++) {
        HttpURLConnection conn = null
        try {     
            conn = new URL(url).openConnection() as HttpURLConnection
            conn.setDoOutput(true)
            conn.setRequestMethod("POST")
            conn.setRequestProperty("Content-Type", "application/json")
            conn.setRequestProperty("charset", "utf-8")
            conn.setRequestProperty("Content-Length", String.valueOf(payload.length()))
            conn.setUseCaches(false)
            conn.setConnectTimeout(5000)
            def os = conn.getOutputStream()
            os.write(payload.getBytes("utf-8"))
            os.flush()
            os.close()
            def responseCode = conn.getResponseCode()
            def responseMessage = conn.getResponseMessage()
            if (responseCode == 202) {
                utilsMessageLib.infoMsg("Power Automate card sent SUCCESSFULLY to Teams!")
                success = true
            } else {
                utilsMessageLib.errorMsg("Attempt ${attempt}: Request failed - Return code ${responseCode} ${responseMessage}")
            }
        } catch (SocketTimeoutException ste) {
            utilsMessageLib.warnMsg("Connection timeout on attempt ${attempt}")
        } catch (Exception e) {
            utilsMessageLib.errorMsg("Failed in attempt ${attempt}: ${e.message}")
        } finally {
            if (conn != null) {
                try {
                    conn.getInputStream().close()
                } catch (Exception e) {
                }
                conn.disconnect()
            }
        }        
        
        if (!success) {
            utilsMessageLib.errorMsg(" All attempts to send the POST failed.")
        } 
    }
}

/**
 * httpGet
 * Método realiza GET para a URI especificada
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 **/
def httpGet(def uri, def user, def pass, def failMessage) {

   HttpURLConnection conn = null
   BufferedReader reader = null
   try {

       conn = new URL(uri).openConnection() as HttpURLConnection
       conn.setRequestMethod("GET")
       conn.setRequestProperty("Content-Type", "application/json")
       conn.setRequestProperty("charset", "utf-8")
       conn.setRequestProperty("Authorization", "Basic " + "${user}:${pass}".bytes.encodeBase64().toString())

       reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))
       StringBuilder response = new StringBuilder()
       String line

       while ((line = reader.readLine()) != null) {
           response.append(line)
       }

       return response.toString()
   } catch (IOException e) {
       println "Fail in GET ${failMessage} - Error: ${e.message}"
       return null
   } finally {
       if (reader != null) {
           try {
            reader.close()
           } catch (IOException e) {

           }
       }
       if (conn != null) {
           conn.disconnect()
       }
   }
}

/**
 * httpGetBearer
 * Método realiza GET para a URI especificada utilizando Bearer
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 **/
def httpGetBearer(def uri, def token, def failMessage) {

   HttpURLConnection conn = null
   BufferedReader reader = null
   try {

       conn = new URL(uri).openConnection() as HttpURLConnection
       conn.setRequestMethod("GET")
       conn.setRequestProperty("Content-Type", "application/json")
       conn.setRequestProperty("charset", "utf-8")
       conn.setRequestProperty("Authorization", "Bearer " + "${token}")

       reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))
       StringBuilder response = new StringBuilder()
       String line

       while ((line = reader.readLine()) != null) {
           response.append(line)
       }

       return response.toString()
   } catch (IOException e) {
       println "Fail in GET ${failMessage} - Error: ${e.message}"
       return null
   } finally {
       if (reader != null) {
           try {
            reader.close()
           } catch (IOException e) {

           }
       }
       if (conn != null) {
           conn.disconnect()
       }
   }
}

/**
 * httpPut
 * Método realiza o PUT de payload para a URI especificada
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@experian.com>
 **/
def httpPut(def uri, def user, def pass, def successResponseCode, def payload, def successMessage, def failMessage) {

    HttpURLConnection conn = null
    BufferedReader reader = null
    def responseCode = null
    def responseMessage = null
    try {      
        conn = new URL(uri).openConnection() as HttpURLConnection
        conn.setDoOutput(true)
        conn.setRequestMethod("PUT")
        conn.setRequestProperty("Content-Type", "application/json")
        conn.setRequestProperty("charset", "utf-8")
        conn.setRequestProperty("Content-Length", String.valueOf(payload.length()))
        conn.setRequestProperty("Authorization", "Basic " + "${user}:${pass}".bytes.encodeBase64().toString())
        conn.setUseCaches(false)
        conn.setConnectTimeout(5000)
        def os = conn.getOutputStream()
        os.write(payload.getBytes("utf-8"))
        os.flush()
        os.close() 
        responseCode = conn.getResponseCode()
        responseMessage = conn.getResponseMessage()
        if (responseCode == successResponseCode) {
            println "Success in PUT ${successMessage}!"
        } else {
            println "Failed in PUT ${failMessage} - Return code: ${responseCode} - Error message: ${responseMessage}"
        }
    } catch (SocketTimeoutException ste) {
        println "Connection timeout!"
    } catch (Exception e) {
        println "Failed in PUT ${failMessage} - Return code: ${responseCode} - Error message: ${responseMessage}"
    } finally {
        if (reader != null) {
            try {
                reader.close()
            } catch (IOException e) {
            }
        }
        if (conn != null) {
            try {
                conn.getInputStream().close()
            } catch (Exception e) {
            }
            conn.disconnect()
        }
    }
}

/**
 * httpPutBearer
 * Método realiza o PUT de payload para a URI especificada com autenticação Bearer
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@experian.com>
 **/
def httpPutBearer(def uri, def pass, def successResponseCode, def payload, def successMessage, def failMessage) {

    HttpURLConnection conn = null
    BufferedReader reader = null
    def responseCode = null
    def responseMessage = null
    try {      
        conn = new URL(uri).openConnection() as HttpURLConnection
        conn.setDoOutput(true)
        conn.setRequestMethod("PUT")
        conn.setRequestProperty("Content-Type", "application/json")
        conn.setRequestProperty("charset", "utf-8")
        conn.setRequestProperty("Content-Length", String.valueOf(payload.length()))
        conn.setRequestProperty("Authorization", "Bearer " + "${pass}")
        conn.setUseCaches(false)
        conn.setConnectTimeout(5000)
        def os = conn.getOutputStream()
        os.write(payload.getBytes("utf-8"))
        os.flush()
        os.close() 
        responseCode = conn.getResponseCode()
        responseMessage = conn.getResponseMessage()
        if (responseCode == successResponseCode) {
            println "Success in PUT ${successMessage}!"
        } else {
            println "Failed in PUT ${failMessage} - Return code: ${responseCode} - Error message: ${responseMessage}"
        }
    } catch (SocketTimeoutException ste) {
        println "Connection timeout!"
    } catch (Exception e) {
        println "Failed in PUT ${failMessage} - Return code: ${responseCode} - Error message: ${responseMessage}"
    } finally {
        if (reader != null) {
            try {
                reader.close()
            } catch (IOException e) {
            }
        }
        if (conn != null) {
            try {
                conn.getInputStream().close()
            } catch (Exception e) {
            }
            conn.disconnect()
        }
    }
}

return this
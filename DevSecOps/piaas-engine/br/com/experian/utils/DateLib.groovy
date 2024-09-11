import java.util.Calendar
import java.time.YearMonth
import java.text.SimpleDateFormat

/**
 * currentDate
 * Método retorna a data atual
 * @version 5.0.0
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 * @return  
 **/
def currentDate() {
    Date date = new Date()
    def now = date.format("yyyy-MM-dd hh:mm:ss")

    return now
}

return this
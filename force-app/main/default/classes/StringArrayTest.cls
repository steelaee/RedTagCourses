public class StringArrayTest{
    public static List<String> generateStringArray(Integer num){
        List<String> strList = new List<String>();
        for(Integer i = 0; i < num; i++){
            strList.add('Test ' + i);
        }
        
        return strList;
    }
}
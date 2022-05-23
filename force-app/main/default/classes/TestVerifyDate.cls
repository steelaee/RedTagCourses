@isTest
public class TestVerifyDate {
    @isTest static void date2within20daydate1(){
		Date returnDate1 = VerifyDate.CheckDates(date.valueOf('2020-02-14'), date.valueOf('2020-02-24'));
        System.assertEquals(date.valueOf('2020-02-24'), returnDate1);
    }
    @isTest static void date2notwithin20daydate1(){
		Date returnDate2 = VerifyDate.CheckDates(date.valueOf('2020-02-14'), date.valueOf('2020-03-24'));
        System.assertEquals(date.valueOf('2020-02-29'), returnDate2);
    }
}
public class Example {
    public static void main(String... args) {
//#     |  a |            |   a    |
        String myString = "string a";
//#     |  b ||    d  |   |   c    |
        Object strAsObj = "string b";
//#     |  d |               |  e    ||   d  |
        String otherString = (String) strAsObj;
    }
}

//:: cases BoogieExamplePass
//:: tools silicon
//:: verdict Pass

public class BoogieExample {

  /*@
    ensures 100 < n ==> \result == n - 10;  // This postcondition is easy to check by hand
    ensures n <= 100 ==> \result == 91;     // Do you believe this one is true?
  @*/
  public static int F(int n) {
    int r;
    if (100 < n) {
      r = n - 10;
    } else {
      r = F(n + 11);
      r = F(r);
    }
    return r;
  }

}



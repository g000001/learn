using System;
using System.Linq;

class LinqFoo
{
  static string foo (string s)
  {
    Console.WriteLine(s);
    return s;
  }

  static void Main () {
    string[] text = { "Albert was here",
                      "Burke slept late",
                      "Connor is happy" };
    /*
    var tokens = text.Select(s => s.Split(' '));

    foreach (string[] line in tokens)
      {
        foreach (string token in line)
          {
            Console.Write("{0}.", token);
          }
      }
    Console.Write("\n");
    */

//Console.Write("{0}", s)
    var x = text.Select(s => foo(s));

    foreach(string line in x)
      {
        line + line;
      }

  }
}


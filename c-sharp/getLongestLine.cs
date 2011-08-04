using System;
using System.Linq;

public class LinqFoo {
  public static void Main(string[] args) {
    string[] lines = System.IO.File.ReadAllLines(@args[0]);

    int maxlen = lines.Max(s => s.Length);
    var foo = lines.Where(s => s.Length == maxlen);

    foreach(string line in foo)
      {
        Console.WriteLine(line.ToUpper());
      }

  }
}


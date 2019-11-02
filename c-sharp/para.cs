using System;
using System.Threading.Tasks;

class Program
{
  static void Main(string[] args)
  {
    for (int i = 0; i < 10; i++) Console.Write("{0} ", i);
    Console.WriteLine("by serial");

    Parallel.For(0, 10, (n) => Console.Write("{0} ", n));
    Console.WriteLine("by parallel");
  }
}
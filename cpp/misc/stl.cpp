#include <vector>
#include <list>
#include <iostream>
using namespace std;

int main()
{
  vector<int> v1(3), v2(3);
  list<int> l1(3);
  v1[0] = 2;
  v1[1] = 1;
  v1[2] = 7;

  copy(v1.begin(), v1.end(), l1.begin());

  int i = 0;
  for(; i < v1.size(); ++i) {
    cout << v1[i] << endl;
  }

  {
    list<int>::iterator e = l1.begin();
    for(; e != l1.end(); ++e) {
      cout << *e << endl;
    }
  }

  return 0;
}

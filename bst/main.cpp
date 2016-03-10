#include <iostream>
#include <cstdlib>
#include "BST.cpp"

using namespace std;

int main(){

	int input[7] = {3,6,7,5,2,9,1};

	BST bst;
	for(int i = 0;i < 7;i++)
	{
		bst.AddLeaf(input[i]);
		cout << input[i] << " ";

	}
	cout << endl << "====================" << endl;

	bst.PrintInOrder();
	cout << endl;
	bst.PrintChildren(bst.ReturnRootKey());
	cout << endl << "The smallest value in the tree is " << bst.FindSmallest() << endl;


	return 0;
}
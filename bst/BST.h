class BST{

private:
	struct node{

		int key;
		node* left;
		node* right;
	};

	node* root;

	node* CreateLeaf(int key);
	void AddLeafPrivate(int key,node* Ptr);
	void PrintInOrderPrivate(node* Ptr);
	node* ReturnNode(int key);
	node* ReturnNodePrivate(int key, node* Ptr);
	int FindSmallestPrivate(node* Ptr);
public:

	BST();
	void AddLeaf(int key);
	void PrintInOrder();
	int ReturnRootKey();
	void PrintChildren(int key);
	int FindSmallest();


};
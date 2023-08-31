# Node class
class Node:
    # Constructor to initialize the node object
    def __init__(self, data):
        self.data = data
        self.next = None

# Reverse a linked list by Iterative Method:
class LinkedList:
 
    # Function to initialize head
    def __init__(self):
        self.head = None
 
    # Function to reverse the linked list
    def reverse(self):
        prev = None
        current = self.head
        while(current is not None):
            next = current.next
            current.next = prev
            prev = current
            current = next
        self.head = prev
 
    # Function to insert a new node at the beginning
    def push(self, new_data):
        new_node = Node(new_data)
        new_node.next = self.head
        self.head = new_node
 
    # Utility function to print the LinkedList
    def printList(self):
        temp = self.head
        while(temp):
            print(temp.data, end=" ")
            temp = temp.next



# Reverse a linked list using Recursion:
class LinkedList:
    def __init__(self):
        self.head = None  # Head of list
 
    # Method to reverse the list
    def reverse(self, head):
 
        # If head is empty or has reached the list end
        if head is None or head.next is None:
            return head
 
        # Reverse the rest list
        rest = self.reverse(head.next)
 
        # Put first element at the end
        head.next.next = head
        head.next = None
 
        # Fix the header pointer
        return rest
 
    # Returns the linked list in display format
    def __str__(self):
        linkedListStr = ""
        temp = self.head
        while temp:
            linkedListStr = (linkedListStr +
                             str(temp.data) + " ")
            temp = temp.next
        return linkedListStr
 
    # Pushes new data to the head of the list
    def push(self, data):
        temp = Node(data)
        temp.next = self.head
        self.head = temp



# Reverse a linked list by Tail Recursive Method:
class LinkedList:
 
    # Function to initialize head
    def __init__(self):
        self.head = None
 
    def reverseUtil(self, curr, prev):
 
        # If last node mark it head
        if curr.next is None:
            self.head = curr
 
            # Update next to prev node
            curr.next = prev
            return
 
        # Save curr.next node for recursive call
        next = curr.next
 
        # And update next
        curr.next = prev
 
        self.reverseUtil(next, curr)
 
    # This function mainly calls reverseUtil()
    # with previous as None
 
    def reverse(self):
        if self.head is None:
            return
        self.reverseUtil(self.head, None)
 
    # Function to insert a new node at the beginning
 
    def push(self, new_data):
        new_node = Node(new_data)
        new_node.next = self.head
        self.head = new_node
 
    # Utility function to print the linked LinkedList
    def printList(self):
        temp = self.head
        while(temp):
            print (temp.data, end=" ")
            temp = temp.next


# Reverse a linked list using Stack:
 
class Solution:
 
    # Program to reverse the linked list
    # using stack
    def reverseLLUsingStack(self, head):
 
        # Initialise the variables
        stack, temp = [], head
 
        while temp:
            stack.append(temp)
            temp = temp.next
 
        head = temp = stack.pop()
 
        # Until stack is not
        # empty
        while len(stack) > 0:
            temp.next = stack.pop()
            temp = temp.next
 
        temp.next = None
        return head
 
 
# Driver Code
if __name__ == "__main__":
    head = ListNode(1, ListNode(2, ListNode(3, ListNode(4))))
    print("Given linked list")
    temp = head
    while temp:
        print(temp.val, end=' ')
        temp = temp.next
    obj = Solution()
    print("\nReversed linked list")
    head = obj.reverseLLUsingStack(head)
    while head:
        print(head.val, end=' ')
        head = head.next



l1 = [2,4,3]
l2 = [5,6,4]

class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

# My not worked example
class Solution_b:
    def addTwoNumbers(self, l1: ListNode, l2: ListNode) -> ListNode:
        part = 0
        cur1 = l1
        cur2 = l2
        resultc = None
        
        while cur1.next or cur2.next:
            if cur1.val + cur2.val < 10:
                resultc = ListNode(cur1.val + cur2.val + part, resultc)
            else:
                part = 1
                resultc = ListNode((cur1.val + cur2.val) % 10, resultc)

            if cur1.next:
                cur1 = cur1.next
            if cur2.next:
                cur2 = cur2.next
            print (resultc)

        if cur1.val < 10 or cur2.val < 10:
            resultc = ListNode(cur1.val + cur2.val + part, resultc)
        else:
            part = 1
            resultc = ListNode((cur1.val + cur2.val) % 10, resultc)

        print (resultc)
        return resultc


# Worked solution
class Solution:
    def addTwoNumbers(self, l1: ListNode, l2: ListNode) -> ListNode:
        dummyHead = ListNode(0)
        tail = dummyHead
        carry = 0

        while l1 is not None or l2 is not None or carry != 0:
            digit1 = l1.val if l1 is not None else 0
            digit2 = l2.val if l2 is not None else 0

            sum = digit1 + digit2 + carry
            digit = sum % 10
            carry = sum // 10

            newNode = ListNode(digit)
            tail.next = newNode
            tail = tail.next

            l1 = l1.next if l1 is not None else None
            l2 = l2.next if l2 is not None else None

        result = dummyHead.next
        dummyHead.next = None
        return result



s = Solution()
print(s.addTwoNumbers(l1, l2))

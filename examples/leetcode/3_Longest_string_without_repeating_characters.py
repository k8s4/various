# My shitty example
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        temp = []
        result = []
        for i in range(0, len(s)):
            if s[i] in temp:
                temp = [] 
            temp.append(s[i])

            if len(temp) >= len(result):
                result = temp
        return len(result)


# Modified
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        n = len(s)
        temp = set()
        result = 0
        left = 0

        for i in range(n):
            if s[i] not in temp:
                temp.add(s[i])
                result = max(result, i - left + 1)
            else:
                while s[i] in temp:
                    temp.remove(s[left])
                    left += 1
                temp.add(s[i])
        return result

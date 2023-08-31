nums = [3,2,4]
target = 6

class Solution:
    def twoSum(self, nums: list[int], target) -> list[int]:
        max = len(nums)
        for i in range(max - 1):
            for j in range(i + 1, max):
                if nums[i] + nums[j] == target:
                    return [i, j]
        return []

    def twoSumHash(self, nums: list[int], target) -> list[int]:
        map = {}
        max = len(nums)

        for i in range(max):
            comp = target - nums[i]
            if comp in map:
                return [map[comp], i]
            map[nums[i]] = i
        return []

s = Solution()
print(s.twoSumHash(nums, target))

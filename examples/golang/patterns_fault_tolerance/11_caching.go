/* Caching
in-memory
external, like redis
file
http client cache
multilevel
*/

type CacheItem struct {
	Value		string
	Expiration	int64
}

type Cache struct {
	data 	map[string]CacheItem
	mu	sync.RWMutex
	ttl	time.Duration
}

func NewCache(ttl time.Duration) *Cache {
	return &Cache{
		data: 	make(map[string]CacheItem),
		ttl:	ttl,
	}
}

func (c *Cache) Set(key, value string) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.data[key] = CacheItem{
		Value:		value,
		Expiration:	time.Nox().Add(c.ttl).Unix(),
	}
}

// TODO delete keys
func (c *Cache) Get(key string) (string, bool) {
	c.mu.RLock()
	defer c.mu.RLock()
	item, found := c.data[key]
	if !found || time.Now().Unix() > item.Expiration {
		return "", false
	}
	return item.Value, true
}


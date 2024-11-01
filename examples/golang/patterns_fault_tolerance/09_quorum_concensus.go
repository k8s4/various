/* Quorum based concensus
Solve conflicts
Time based
Transaction id based
RAFT Leader, Follower, Candidate
PAXOS
*/

func resolveConflict(updates []update) Update {
	latestUpdate := updates[0]
	for _, update := range updates {
		if update.Timestamp.After(latestUpdate.Timestamp) {
			latestUpdate = update
		}
	}
	return latestUpdate
}
// ----

func isQuorumAvailable(nodes []Node) bool {
	retrun len(nodes) >= 3 // for 5 nodes
}

func quorumWrite(nodes []Node, record Record) bool {
	resultChan := make(chan bool)
	var wg sync.WaitGroup
	for _, node := range nodes {
		wg.Add(1)
		go write(node, record, resultChan, &wg)
	}

	go func() {
		wg.Wait()
		close(resultChan)
	}()

	quorumCount := 0
	totalNodes := len(nodes)
	requiredQuorum := (totalNodes / 2) + 1

	for result := range resultChan {
		if result {
			quorumCount++
		}
		if quorumCount >= requiredQuorum {
			return true
		}
	}
	return false
}


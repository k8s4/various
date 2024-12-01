package main

import (
  "net/http"
  "log"
  "sync/atomic"
  "time"
)

var (
  ch = make(chan struct{})
  cl  = http.Client{}
  ctr int64
  gg  = 5_000
)

func main() {
  t := time.NewTicker(333 * time.Millisecond)

  for i := 0; i < gg; i++ {
    go google()

    select {
    case <-t.C:
      log.Println("goroutines:", i)
    default:
    }
  }

  log.Println("goroutines:", gg)
  log.Println("closing channel")
  close(ch)

  for range t.C {
    log.Println("sucessful GETs:", atomic.LoadInt64(&ctr))
    if atomic.LoadInt64(&ctr) == int64(gg) {
      return
    }
  }
}

func google() {
  <-ch

  cl.Get("https://www.google.com/")
  atomic.AddInt64(&ctr, 1)
}

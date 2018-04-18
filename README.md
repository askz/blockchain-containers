# BLOCKCHAIN CONTAINERS

This experimental project aims at containerizing blockchain software like full nodes, ElectrumX servers, explorers.  
The goal is to make it simple to deploy any of those three components very easily, on any machine, anywhere.

This project's Dockerfiles (for other coins than bitcoin) are fully inspired from [Rui Marinho](https://github.com/ruimarinho)'s very very good [work](https://github.com/ruimarinho/docker-bitcoin-core).

Unfortunately I'm not able at the time of writing, to make alpine images work.  
PRs are welcome !

You'll find how to use each project in their respective folders.

TODO:
  * Komodo
    * [ ] Manual fetch params process, before starting images
    * [ ] docker-compose scale should work (not tested yet, but this would require work with volumes...)
    * [ ] Add an explorer to compose files
    * [ ] Monitoring & alerts
    * [ ] Tests, tests & tests.
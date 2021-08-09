Hello,

This is the home task assignment project. 
The result of it is the running Consul cluster single units and Consul-app service which could interact with the consul client inside the docker. As a collateral service Jenkins would be started as well 

Prerequisites: 
-	Debian-lie OS;
-	Docker installed;
-	${USER} – should have ability to run docker in non-privileged mode
-	Ports 8080, 8888, 8500, 8600 are open and could be accessed from the outside of the host system;

Steps to deploy test service:
1.	Run “provisioner.sh”
2.	After Jenkins is deployed please access it via the http://[host_address]:8888 , assumably http://localhost:8888 
3.	Trigger “Build” job with the http pull link to this repo
4.	Trigger “Run” job.
After jobs execution the “Consul-app” should be build and running. 
Consul-app is the web service which could interact with the local consul entity and manipulate with kv parameters. You can access it via http://[host_address]:8080, assumably http://localhost:8080 . 

The service registration example could be found in the “registration.json”. The registration command is: 
```bash
curl --request PUT --data @registration.json http://127.0.0.1:8500/v1/catalog/register 
```

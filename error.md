# Pipeline Troubleshooting & Execution Log

## Encountered Errors & Resolutions

### 1. Missing Directory Reference in Script (Stage 6)
* **Error:** `./run_pipeline.sh: line 42: cd: ansible: No such file or directory`
* **Cause:** The script attempted to change directories into `ansible` from an incorrect relative base path.
* **Resolution:** Adjusted the script to execute playbooks from the repository root using explicit relative paths (`ansible/playbook.yml -i ansible/inventory`).

### 2. Syntax Error in Directory Change Command
* **Error:** `./run_pipeline.sh: line 43: cd: too many arguments`
* **Cause:** Erroneously prefixed `ansible-playbook` command directly onto the `cd` statement.
* **Resolution:** Separated the directory context and execution command cleanly.

### 3. Immediate Post-Deployment BGP State as Idle
* **Symptom:** Running health checks immediately after container recreation reported BGP peers in `Idle` state and OSPF uptime as `never`.
* **Cause:** FRR container daemons require a brief convergence window to negotiate TCP sessions and hello timers upon startup.
* **Resolution:** Introduced an automated 5-second sleep delay (`sleep 5`) prior to executing protocol health verifications.

### 4. Successful Convergence Verification Output
* **Post-Fix Output:**
Neighbor ID     Pri State           Up Time         Dead Time Address           Interface                     RXmtL RqstL DBsmL
  1.1.1.1           1 Full/-          0.112s           39.877s 172.17.0.2        eth0:172.17.0.3                   1     0     0

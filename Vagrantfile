definitions = {
    "db1.pmm2lab.172.17.17.11.nip.io" => ["172.17.17.11", "pboros/pmm2lab-ps80"],
    "db2.pmm2lab.172.17.17.12.nip.io" => ["172.17.17.12", "pboros/pmm2lab-ps80"],
    "sysbench.pmm2lab.172.17.17.21.nip.io" => ["172.17.17.21", "pboros/pmm2lab-docker"],
    "pmm.pmm2lab.172.17.17.31.nip.io" => ["172.17.17.31", "pboros/pmm2lab-docker"]
}
machines = definitions.keys()
ips = definitions.values().map{|x| x[0]}
box = definitions.values().map{|x| x[1]}
num_machines = machines.length

Vagrant.configure("2") do |config|
    (1..num_machines).each do |machine_id|
        config.ssh.insert_key = false
        config.vm.synced_folder "./ansible", "/ansible"
        config.vm.define machines[machine_id-1] do |machine|
            machine.vm.box = box[machine_id-1]
            machine.vm.network "private_network", ip: ips[machine_id-1]
            machine.vm.hostname = machines[machine_id-1]
            machine.vm.provider "virtualbox" do |vb|
                vb.memory = 1024
            end

            if machine_id == num_machines
                machine.vm.provision "ansible_local" do |ansible_pmm|
                    ansible_pmm.groups = {
                        "pmm" => ["pmm.pmm2lab.172.17.17.31.nip.io"]
                    }
                    ansible_pmm.config_file = "ansible/ansible.cfg"
                    ansible_pmm.limit = "pmm"
                    ansible_pmm.playbook = "ansible/pmm_local.yml"
                end
                machine.vm.provision "ansible_local" do |ansible_master|
                    ansible_master.groups = {
                        "master" => ["db1.pmm2lab.172.17.17.11.nip.io"]
                    }
                    ansible_master.config_file = "ansible/ansible.cfg"
                    ansible_master.limit = "master"
                    ansible_master.playbook = "ansible/master_local.yml"
                end
                machine.vm.provision "ansible_local" do |ansible_slave|
                    ansible_slave.groups = {
                        "slave" => ["db2.pmm2lab.172.17.17.12.nip.io"]
                    }
                    ansible_slave.config_file = "ansible/ansible.cfg"
                    ansible_slave.limit = "slave"
                    ansible_slave.playbook = "ansible/slave_local.yml"
                end
                machine.vm.provision "ansible_local" do |ansible_clone|
                    ansible_clone.groups = {
                        "dbs" => ["db1.pmm2lab.172.17.17.11.nip.io", "db2.pmm2lab.172.17.17.12.nip.io"]
                    }
                    ansible_clone.config_file = "ansible/ansible.cfg"
                    ansible_clone.playbook = "ansible/clone.yml"
                    ansible_clone.limit = "dbs"
                    ansible_clone.raw_arguments = ["-e source=db1.pmm2lab.172.17.17.11.nip.io -e target=db2.pmm2lab.172.17.17.12.nip.io"]
                end
                machine.vm.provision "ansible_local" do |ansible_sysbench|
                    ansible_sysbench.groups = {
                        "sysbench" => ["sysbench.pmm2lab.172.17.17.21.nip.io"]
                    }
                    ansible_sysbench.config_file = "ansible/ansible.cfg"
                    ansible_sysbench.limit = "sysbench"
                    ansible_sysbench.playbook = "ansible/sysbench_local.yml"
                end
            end
        end
    end
end 

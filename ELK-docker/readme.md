Unduh Elasticsearch di host yang sama dengan Ansible atau di server lokal:
```
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.1-linux-x86_64.tar.gz
tar -xzvf elasticsearch-7.17.1-linux-x86_64.tar.gz
```

Buat Sertifikat dengan elasticsearch-certutil:

```
cd elasticsearch-7.17.1/bin
./elasticsearch-certutil ca --out ./certs/elastic-stack-ca.p12
./elasticsearch-certutil cert --ca ./certs/elastic-stack-ca.p12 --out ./certs/elastic-certificates.p12
```

```
ansible-playbook -i inventory.ini install-docker.yml
ansible-playbook -i inventory.ini elk-setup.yml
```

buat base84 password
```
echo -n 'elastic:asdjhk32478fwbnfsd' | base64
```
Perbarui ilm-policy.yml ganti Auth nya

```
ansible-playbook -i inventory.ini ilm-policy.yml
```

```
ansible-playbook -i inventory.ini python3-pip.yml
ansible-playbook -i inventory.ini filebeat-setup.yml
```
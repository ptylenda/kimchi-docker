# kimchi-docker
Docker image for Kimchi (https://github.com/kimchi-project/kimchi), CentOS-systemd based.

Example usage:
```
docker run -it -p 8001:8001 -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro ptylenda/kimchi-docker
```

On Ubuntu hosts it may be required to disable AppArmor libvirt profile (solution found in https://docs.openstack.org/kolla/newton/quickstart.html):
```
sudo apparmor_parser -R /etc/apparmor.d/usr.sbin.libvirtd
```

{% if grains['os'] == 'Ubuntu' %}
docker_repo:
  pkgrepo.managed:
    - humanname: Docker CE
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ salt['grains.get']('lsb_distrib_codename') }} stable
    - keyurl: https://download.docker.com/linux/ubuntu/gpg
    - gpgcheck: 1

docker_repo_key:
  cmd.run:
    - name: curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
{% endif %}

docker-ce:
  pkg.latest:
    - require:
      - pkgrepo: docker_repo
      - cmd: docker_repo_key

docker-py:
  pip.installed:
    - require:
      - pkg: docker-ce
      - pip: pip-update

python-pip:
  pkg.latest

pip-update:
  pip.uptodate:
    - require:
      - pkg: python-pip

git:
  pkg.latest

kayaklau.ch_docker_repo:
  git.latest:
    - name: https://github.com/binghamchris/kayaklan.ch_docker.git
    - target: /srv/git/kayaklan.ch_dockera
    - require:
      - pkg: git

binghamchris/kayaklaunch:v1.4:
  dockerng.image_present:
    - build: /srv/git/kayaklan.ch_docker
    - require:
      - pip: docker-py
      - git: kayaklau.ch_docker_repo

kayaklaun.ch:
  dockerng.running:
    - image: binghamchris/kayaklaunch:v1.4
    - detach: True
    - ports: 80/tcp
    - publish_all_ports: True
    - labels:
      - env: test
      - app: kayaklaun.ch
    - require:
      - dockerng: binghamchris/kayaklaunch:v1.4

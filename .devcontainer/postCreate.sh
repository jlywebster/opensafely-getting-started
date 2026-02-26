# install python and dependencies, set up virtualenv
sudo apt update
wget https://github.com/opensafely-core/python-docker/raw/refs/heads/main/v2/dependencies.txt -q -O - | sed 's/^#.*//' | sudo xargs apt-get install --yes --no-install-recommends
pip install virtualenv opensafely
python3 -m virtualenv .venv
rm  -rf .venv/lib
docker container create --name python-v2 ghcr.io/opensafely-core/python:v2
docker cp python-v2:/opt/venv/lib .venv/
docker rm python-v2

# install R and dependencies
echo "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee /etc/apt/sources.list.d/cran.list >/dev/null
sudo /usr/lib/apt/apt-helper download-file 'https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc' /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo apt update
wget https://raw.githubusercontent.com/opensafely-core/r-docker/refs/heads/main/v2/dependencies.txt -q -O - | sed 's/^#.*//' | sudo xargs apt-get install --yes --no-install-recommends
wget https://raw.githubusercontent.com/opensafely-core/r-docker/refs/heads/main/scripts/rprofile-site-append-1.R -q -O - | sudo tee -a /usr/lib/R/etc/Rprofile.site >/dev/null
wget https://raw.githubusercontent.com/opensafely-core/r-docker/refs/heads/main/scripts/rprofile-site-append-2.R -q -O - | sudo tee -a /usr/lib/R/etc/Rprofile.site >/dev/null
docker create --name r-v2 --rm ghcr.io/opensafely-core/r:v2
sudo docker cp r-v2:/usr/local/lib/R/site-library /usr/local/lib/R/
sudo chown -R vscode:vscode /usr/local/lib/R/site-library/


#download and extract latest ehrql source
wget https://github.com/opensafely-core/ehrql/archive/main.zip -P .devcontainer
unzip -o .devcontainer/main.zip -d .devcontainer/
rm .devcontainer/main.zip
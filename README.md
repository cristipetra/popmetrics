# Welcome to Popmetrics iOS app project

Developer Guide

1. Upload your ssh key to gitlab
If you don't have one generate it with the following commands. Use an empty passphrase (just hit enter)
``` 
cd ~
ssh-keygen -t rsa
```
display it
```
cat ~/.ssh/id_rsa.pub 
```
Copy it and add it to Gitlab.

2. Install cocoapods (https://cocoapods.org/)
```
sudo gem install cocoapods
```

3. Install Homebrew (https://brew.sh/)
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

4. Install git command line
```
brew install git
```

5. Clone the project repository 

We recommend keeping the same folder structure so current and future scripts work right of the bat.
```
mkdir -p ~/code/popmetrics
cd ~/code/popmetrics
git clone git@git.popmetrics.io:mobile/ipopmetrics.git
```

6. Setup cocoapods dependencies

```
cd ~/code/popmetrics/ipopmetrics
pod update
```
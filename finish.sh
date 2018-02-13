# curl -u ""$RANCHER_USER":"$RANCHER_PASS"" \
# -X POST \
# 'http://rancher.flowz.com:8080/v2-beta/projects/1a29/services/1s120?action=finishupgrade'
#
# curl -u ""$RANCHER_USER":"$RANCHER_PASS"" \
# -X POST \
# 'http://rancher.flowz.com:8080/v2-beta/projects/1a29/services/1s302?action=finishupgrade'

echo "call finish.sh file"
echo $TRAVIS_BUILD_NUMBER

echo "TRAVIS_PULL_REQUEST is $TRAVIS_PULL_REQUEST"
echo "TRAVIS_TAG is $TRAVIS_TAG"
echo "TRAVIS_BUILD_NUMBER is $TRAVIS_BUILD_NUMBER"


if [ "$TRAVIS_BRANCH" = "develop" ]; then

  # Is this not a Pull Request?
  if [ "$TRAVIS_PULL_REQUEST" = false ]; then

    # Is this not a build which was triggered by setting a new tag?
    if [ -z "$TRAVIS_TAG" ]; then
      echo -e "Starting to tag commit.\n"

      git config --global user.email

      git config --global user.name


      # git config --global credential.helper 'cache --timeout=3600'
      git config --global user.email "arpitap@officebeacon.com"
      git config --global user.name "80017"



      # Add tag and push to master.
      git tag -a v${TRAVIS_BUILD_NUMBER} -m "Travis build $TRAVIS_BUILD_NUMBER pushed a tag."
      git push origin --tags
      git fetch origin

      echo -e "Done magic with tags.\n"
  fi
  fi
fi

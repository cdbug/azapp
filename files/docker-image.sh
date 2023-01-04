if [[ "$(docker images -q az-image 2> /dev/null)" == "" ]];
then
  echo $PWD
  cd ./az-app

  docker build -t az-image .
fi
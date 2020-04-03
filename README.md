# appdynamics-docker


appdynamics folder comes from

curl -H "Accept: application/zip" https://codeload.github.com/benemon/fis-java-appdynamics-plugin/zip/master -o /deployments/appdynamics.zip

The jar file is a very simple spring-boot app 


docker build . -t appd:1.0
docker run appd:1.0

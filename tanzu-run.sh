#!/bin/sh
tanzu apps workload create spring-boot-admin-demo \
    --git-repo https://github.com/benwilcock/spring-boot-admin-demo \
    --git-branch main \
    --type web \
    --label app.kubernetes.io/part-of=spring-boot-admin-demo \
    --label tanzu.app.live.view=false \
    --label tanzu.app.live.view.application.name=spring-boot-admin-demo \
    --annotation autoscaling.knative.dev/minScale=1 \
    --namespace default \
    --env "NAMESPACE=default" \
    --env "DOMAIN=apps.192.168.50.105.nip.io" \
    --env "INGRESS_PORT=31080" \
    --env "JAVA_TOOL_OPTIONS=-Dmanagement.server.port=8080" \
    --env "SPRING_PROFILES_ACTIVE=tap" \
    --yes

tanzu apps workload tail spring-boot-admin-demo --since 10m --timestamp

watch tanzu apps workload get spring-boot-admin-demo

firefox http://spring-boot-admin-demo.default.apps.192.168.50.105.nip.io:31080/
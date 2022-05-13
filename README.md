# Spring Boot Admin Demo

Demonstrating adding Spring Boot Admin features to TAP `iterate` clusters.

Assumptions:

* Spring knowledge
* GitHub CLI
* Git CLI
* VSCode
* Tanzu Application Platform ('iterate' profile)

Spring boot dependencies:

* Spring Web
* Spring Boot Admin Server
* Spring Boot Admin Client
* Spring Actuators
* Spring DevTools
* Spring Security

# Instructions

## Start the project

1. Go to https://start.spring.io
1. Set 'Artifact' to 'spring-boot-admin-demo'
1. Add dependencies listed above.
1. Click 'generate' to download the 'spring-boot-admin-demo.zip' file
1. Extract the spring-boot-admin-demo.zip file
1. Cd to 'spring-boot-admin-demo' folder
1. Open folder in VSCode `code .`

## Make some code changes

Annotate the `SpringBootAdminDemoApplication` class:

`@EnableAdminServer`

Add security configuration to allow actuators:

```java
    @Configuration
    public static class SecurityPermitAllConfig extends WebSecurityConfigurerAdapter {
        @Override
        protected void configure(HttpSecurity http) throws Exception {
            http.authorizeRequests().anyRequest().permitAll()  
                .and().csrf().disable();
        }
    }
```

Add to `application.properties`:

```java
spring.application.name=spring-boot-admin-demo
management.endpoints.web.exposure.include=*
spring.boot.admin.client.url=http://localhost:8080
spring.boot.admin.client.instance.service-base-url=http://localhost:8080
```

A quick test to check the UI comes up:

In the Terminal...

```bash
./mvnw spring-boot:run
```

In the browser...

http://localhost:8080


Create `application-tap.properties`:

```java
spring.boot.admin.ui.public-url=http://${spring.application.name}.${NAMESPACE}.${DOMAIN}
spring.boot.admin.client.url=http://localhost:8080
spring.boot.admin.client.instance.service-base-url=http://${spring.application.name}.${NAMESPACE}.${DOMAIN}
```

## Create a GIT commit

```bash
git init
git add --all
git commit -m "initial commit"
```

## Create a GitHub repo

`gh repo create spring-boot-admin-demo --public --source=. --remote=origin --push`

## Run on TAP cluster

```bash
tanzu apps workload create spring-boot-admin-demo \
    --git-repo https://github.com/<your_github_name>/spring-boot-admin-demo \
    --git-branch main \
    --type web \
    --label app.kubernetes.io/part-of=spring-boot-admin-demo \
    --label tanzu.app.live.view=false \
    --label tanzu.app.live.view.application.name=spring-boot-admin-demo \
    --annotation autoscaling.knative.dev/minScale=1 \
    --namespace default \
    --env "NAMESPACE=default" \
    --env "DOMAIN=apps.example.com" \
    --env "JAVA_TOOL_OPTIONS=-Dmanagement.server.port=8080" \
    --env "SPRING_PROFILES_ACTIVE=tap" \
    --yes
```

Watch the workload deploy (takes a few minutes):

`watch tanzu apps workload get spring-boot-admin-demo`

(look out for the URL to appear)

## Test in browser

http://spring-boot-admin-demo.default.apps.example.com

Click on the green tick once, then again to see all the lovely details.





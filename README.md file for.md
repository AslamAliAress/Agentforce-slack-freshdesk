<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Sure! Here's a well-structured README.md file for your FreshdeskSearchAPI Apex class that includes:

Overview
Features
Setup instructions
How to use it in Agentforce
Example prompt
Notes on Named Credentials
You can include this in your Salesforce project repo or documentation.

📄 README.md
markdown
CopyEdit

# Freshdesk Solution Article Search for Salesforce (Agentforce)

This Apex utility enables Salesforce agents to search Freshdesk **solution articles** using a keyword and return a list of article URLs. It is designed for integration with **Agentforce** using **Agent Actions** or **Flows** via an invocable method.

---

## 🔍 Features

- Performs a callout to Freshdesk’s `/api/v2/search/solutions` endpoint
- Builds direct article URLs using article `id`
- Invocable method for use in Agent Actions / Flows
- Supports dynamic keyword input

---

## 📦 Apex Class Overview

**Class Name:** `FreshdeskSearchAPI`

**Key Methods:**

### `public static List<String> searchSolutionArticleLinks(String keyword)`

- Makes a GET request to the Freshdesk API
- Returns a list of article URLs using article IDs


### `@InvocableMethod searchSolutionArticleLinksInvocable(List<Request> requests)`

- Accepts a keyword input (wrapped)
- Returns a list of `Response` objects containing article URLs
- Designed for use in **Agent Actions** and **Flow Builder**

---

## ⚙️ Setup Instructions

### 1. Create a Named Credential

- **Label:** FreshdeskAPI
- **URL:** `https://efpaper.freshdesk.com`
- **Authentication:** Choose method (e.g., API Key as Username + Blank Password for basic auth)


### 2. Deploy the Apex Class

Ensure the following class is deployed:

```apex
public with sharing class FreshdeskSearchAPI {
    private static final String NAMED_CREDENTIAL = 'FreshdeskAPI';
    private static final String FRESHDESK_DOMAIN = 'https://efpaper.freshdesk.com';

    public class Request {
        @InvocableVariable public String keyword;
    }

    public class Response {
        @InvocableVariable public String articleUrl;
        public Response(String url) {
            this.articleUrl = url;
        }
    }

    @InvocableMethod
    public static List<Response> searchSolutionArticleLinksInvocable(List<Request> requests) {
        List<Response> responses = new List<Response>();
        if (requests == null || requests.isEmpty()) return responses;
        String keyword = requests[0].keyword;
        List<String> urls = searchSolutionArticleLinks(keyword);
        for (String url : urls) {
            responses.add(new Response(url));
        }
        return responses;
    }

    public static List<String> searchSolutionArticleLinks(String keyword) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        String endpoint = 'callout:' + NAMED_CREDENTIAL + '/api/v2/search/solutions?term=' +
                          EncodingUtil.urlEncode(keyword, 'UTF-8');
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());
                List<String> links = new List<String>();
                for (Object item : results) {
                    Map<String, Object> article = (Map<String, Object>) item;
                    if (article.containsKey('id')) {
                        String idStr = String.valueOf(article.get('id'));
                        links.add(FRESHDESK_DOMAIN + '/solution/articles/' + idStr);
                    }
                }
                return links;
            } else {
                return new List<String>();
            }
        } catch (Exception e) {
            return new List<String>();
        }
    }
}


🤖 Using with Agentforce
You can integrate this invocable method into an Agent Action or Flow:
Create a Flow in Salesforce.
Add a Screen element that asks the user:
css
CopyEdit
Enter the keyword to search Freshdesk solution articles:

Add an Action → choose Apex → select:
FreshdeskSearchAPI.searchSolutionArticleLinksInvocable
Map the screen input to the keyword input.
Use the list of article URLs (from Response.articleUrl) as needed.


🧪 Testing (Execute Anonymous)
apex
CopyEdit
List<FreshdeskSearchAPI.Request> inputs = new List<FreshdeskSearchAPI.Request>();
FreshdeskSearchAPI.Request req = new FreshdeskSearchAPI.Request();
req.keyword = 'salesforce';
inputs.add(req);

List<FreshdeskSearchAPI.Response> results = FreshdeskSearchAPI.searchSolutionArticleLinksInvocable(inputs);
for (FreshdeskSearchAPI.Response res : results) {
    System.debug(res.articleUrl);
}


📝 Notes
This class expects the Freshdesk API response to be a flat list of articles.
The link is built using the format:
https://efpaper.freshdesk.com/solution/articles/{id}
Make sure the Named Credential is active and accessible by the user profile or permission set.


📚 Reference
[Freshdesk API Docs]()
[Salesforce Invocable Methods]()
yaml
CopyEdit

---

Let me know if you'd like this as a downloadable file or want it tailored to a specific GitHub format!

Here is a well-structured README.md content for your FreshdeskSearchAPI Apex class, suitable for inclusion in your Salesforce project or documentation repo. It covers overview, features, setup, usage in Agentforce, example prompts, and notes on Named Credentials, as per your request.

# Freshdesk Solution Article Search for Salesforce (Agentforce)

This Apex utility allows Salesforce agents to search Freshdesk **solution articles** by keywords and retrieve article URLs. It integrates with **Agentforce** via **Agent Actions** or **Flows** through an invocable Apex method.

## 🔍 Features

- Calls Freshdesk’s `/api/v2/search/solutions` endpoint to search solution articles by keyword.
- Constructs direct URLs to articles using their IDs.
- Provides an invocable method for use in Salesforce Agent Actions and Flow Builder.
- Supports dynamic keyword input.

## 📦 Apex Class Overview

**Class Name:** `FreshdeskSearchAPI`

### Key Methods:

- `public static List<String> searchSolutionArticleLinks(String keyword)`
  - Makes a GET HTTP callout to Freshdesk API.
  - Parses JSON response and returns a list of article URLs.

- `@InvocableMethod searchSolutionArticleLinksInvocable(List<Request> requests)`
  - Accepts a list of keyword inputs (wrapped in `Request` objects).
  - Returns a list of `Response` objects with article URLs.
  - Designed for seamless integration into Agentforce Agent Actions and Flows.

## ⚙️ Setup Instructions

### 1. Create a Named Credential in Salesforce

- **Label:** FreshdeskAPI  
- **URL:** `https://efpaper.freshdesk.com` (replace with your Freshdesk domain)  
- **Authentication:** Use API Key (enter API key as username, leave password blank for basic auth)

### 2. Deploy the Apex Class

Ensure the following Apex class is deployed into your org:

```apex
public with sharing class FreshdeskSearchAPI {
    private static final String NAMED_CREDENTIAL = 'FreshdeskAPI';
    private static final String FRESHDESK_DOMAIN = 'https://efpaper.freshdesk.com';

    public class Request {
        @InvocableVariable public String keyword;
    }

    public class Response {
        @InvocableVariable public String articleUrl;
        public Response(String url) {
            this.articleUrl = url;
        }
    }

    @InvocableMethod
    public static List<Response> searchSolutionArticleLinksInvocable(List<Request> requests) {
        List<Response> responses = new List<Response>();
        if (requests == null || requests.isEmpty()) return responses;
        String keyword = requests[^0].keyword;
        List<String> urls = searchSolutionArticleLinks(keyword);
        for (String url : urls) {
            responses.add(new Response(url));
        }
        return responses;
    }

    public static List<String> searchSolutionArticleLinks(String keyword) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        String endpoint = 'callout:' + NAMED_CREDENTIAL + '/api/v2/search/solutions?term=' +
                          EncodingUtil.urlEncode(keyword, 'UTF-8');
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());
                List<String> links = new List<String>();
                for (Object item : results) {
                    Map<String, Object> article = (Map<String, Object>) item;
                    if (article.containsKey('id')) {
                        String idStr = String.valueOf(article.get('id'));
                        links.add(FRESHDESK_DOMAIN + '/solution/articles/' + idStr);
                    }
                }
                return links;
            } else {
                return new List<String>();
            }
        } catch (Exception e) {
            return new List<String>();
        }
    }
}
```


## 🤖 Using with Agentforce

Integrate this invocable method into an Agent Action or Flow:

1. Create a Flow in Salesforce.
2. Add a Screen element that prompts the user:

```
Enter the keyword to search Freshdesk solution articles:
```

3. Add an Action → Apex → select:
`FreshdeskSearchAPI.searchSolutionArticleLinksInvocable`
4. Map the screen input to the keyword input.
5. Use the returned list of article URLs (`Response.articleUrl`) as needed.

## 🧪 Testing (Execute Anonymous)

Run this snippet in Execute Anonymous to test functionality:

```apex
List<FreshdeskSearchAPI.Request> inputs = new List<FreshdeskSearchAPI.Request>();
FreshdeskSearchAPI.Request req = new FreshdeskSearchAPI.Request();
req.keyword = 'salesforce';
inputs.add(req);

List<FreshdeskSearchAPI.Response> results = FreshdeskSearchAPI.searchSolutionArticleLinksInvocable(inputs);
for (FreshdeskSearchAPI.Response res : results) {
    System.debug(res.articleUrl);
}
```


## 📝 Notes

- Freshdesk API returns a flat list of articles matching the keyword.
- Articles URLs are constructed as:
`https://efpaper.freshdesk.com/solution/articles/{id}`
- Ensure the Named Credential is active and accessible by the required user profiles or permission sets.
- Use valid Freshdesk domain and API key corresponding to your account.


## 📚 Reference

- Freshdesk API Docs
- Salesforce Invocable Methods

If you want this content packaged as a downloadable file or formatted for GitHub with badges and templates, I can help with that too.

<div style="text-align: center">⁂</div>

[^1]: https://support.freshdesk.com/support/solutions/articles/226032-using-search-in-freshdesk

[^2]: https://developer.salesforce.com/docs/einstein/genai/guide/agent-apex-generate-spec.html

[^3]: https://developers.freshdesk.com/api/

[^4]: https://salesforce.stackexchange.com/questions/925/documenting-salesforce-com-apex-class-files

[^5]: https://crmsupport.freshworks.com/support/solutions/articles/50000009978-freshdesk-for-salesforce

[^6]: https://lucidwaresolutions.com/sfapexdoc/

[^7]: https://community.freshworks.com/api-and-webhooks-11406/index7.html?sort=publishedAt

[^8]: https://github.com/trailheadapps/apex-recipes/blob/main/README.md

[^9]: https://www.scribd.com/document/684194016/Freshdesk-List-of-Features

[^10]: https://trailhead.salesforce.com/trailblazer-community/feed/0D54V00007T4JxjSAF


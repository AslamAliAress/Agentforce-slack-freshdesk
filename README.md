

#### Overview
#### Features
#### Setup instructions
#### How to use it in Agentforce
#### Example prompt
#### Notes on Named Credentials
#### You can include this in your Salesforce project repo or documentation.


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

## 📝 Output


Installed slack this:
<img width="1555" height="267" alt="image" src="https://github.com/user-attachments/assets/3b2d4891-ae9f-41f2-a97c-49872ba878da" />

Installed package:
<img width="1571" height="386" alt="image" src="https://github.com/user-attachments/assets/9214530a-b3eb-45ef-956b-270bea87ba4e" />

Manage Slack Connection
<img width="1573" height="583" alt="image" src="https://github.com/user-attachments/assets/ea36fce1-d371-4110-999c-b2b55771be0f" />
<img width="614" height="573" alt="image" src="https://github.com/user-attachments/assets/6c7e5f62-da6c-4d98-aa76-d5a1cfad56e4" />

<img width="1564" height="141" alt="image" src="https://github.com/user-attachments/assets/312c487b-5dea-4c55-8197-52e1c94dbffe" />

Agentforce Connection:
<img width="1895" height="894" alt="image" src="https://github.com/user-attachments/assets/63e9c0b9-9837-48d2-a449-0f28387c6d37" />

Activate the Connection in Slack
<img width="1300" height="990" alt="image" src="https://github.com/user-attachments/assets/c8fc496c-9430-49a3-a64d-160b635d6045" />
<img width="1041" height="951" alt="image" src="https://github.com/user-attachments/assets/9a481e1e-4de1-4d30-9c5a-2c4a5917e2e4" />
<img width="1200" height="717" alt="image" src="https://github.com/user-attachments/assets/142c2012-52d6-4564-9d8f-72583f567243" />

Install the Agent in Slack
<img width="1202" height="946" alt="image" src="https://github.com/user-attachments/assets/40592f26-2ded-4553-ac3a-ff66daca6a2f" />

Output With agent:
<img width="1862" height="907" alt="image" src="https://github.com/user-attachments/assets/22cf538d-5dd2-458a-81ad-859a6b65fe54" />


Freshdesk Name Cred
<img width="1563" height="648" alt="image" src="https://github.com/user-attachments/assets/cad36e53-c69b-45d1-9274-98a11e0171e2" />


Agentforce + Slack + Freshdesk output:
<img width="1887" height="902" alt="image" src="https://github.com/user-attachments/assets/98d84e26-7c3f-4300-ac65-b591035a7ed8" />
<img width="1906" height="960" alt="image" src="https://github.com/user-attachments/assets/ade9822c-f26c-4074-99aa-480733372e2c" />



## 📚 Reference

- Freshdesk API Docs - https://developers.freshdesk.com/api/#list_all_tickets 
- Salesforce Invocable Methods - https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_InvocableMethod.htm

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


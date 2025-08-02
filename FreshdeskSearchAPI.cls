public with sharing class FreshdeskSearchAPI {

    private static final String NAMED_CREDENTIAL = 'FreshdeskAPI';
    private static final String FRESHDESK_DOMAIN = 'https://efpaper.freshdesk.com';

    // Input wrapper class for Invocable method
    public class Request {
        @InvocableVariable(label='Search Keyword' description='Keyword to search solution articles')
        public String keyword;
    }

    // Output wrapper class for Invocable method
    public class Response {
        @InvocableVariable(label='Article URL' description='URL of the Freshdesk solution article')
        public String articleUrl;

        public Response(String url) {
            this.articleUrl = url;
        }
    }

    /**
     * Invocable method for Agent Action to search Freshdesk articles.
     * Accepts a list of Requests (only first will be processed),
     * returns a list of Response objects containing article URLs.
     */
    @InvocableMethod(label='Search Freshdesk Solution Articles' description='Searches Freshdesk solution articles by keyword and returns article URLs.')
    public static List<Response> searchSolutionArticleLinksInvocable(List<Request> requests) {
        List<Response> responses = new List<Response>();
        if (requests == null || requests.isEmpty()) {
            return responses;
        }

        // Use the keyword from the first request only
        String keyword = requests[0].keyword;
        List<String> articleUrls = searchSolutionArticleLinks(keyword);

        // Convert URLs to Response wrapper objects
        for (String url : articleUrls) {
            responses.add(new Response(url));
        }
        return responses;
    }

    /**
     * Searches Freshdesk solution articles for a given keyword.
     * Returns a list of article URLs constructed using the article IDs.
     * 
     * @param keyword The search keyword
     * @return List of article URLs as strings
     */
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
            System.debug('Raw response: ' + res.getBody());

            if (res.getStatusCode() == 200) {
                // Parse root JSON as List<Object>
                List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());

                List<String> articleLinks = new List<String>();
                for (Object item : results) {
                    Map<String, Object> articleData = (Map<String, Object>) item;
                    if (articleData.containsKey('id') && articleData.get('id') != null) {
                        String idStr = String.valueOf(articleData.get('id'));
                        String articleUrl = FRESHDESK_DOMAIN + '/solution/articles/' + idStr;
                        articleLinks.add(articleUrl);
                    }
                }
                return articleLinks;
            } else {
                System.debug('Search failed: ' + res.getStatus() + ' - ' + res.getBody());
                return new List<String>();
            }
        } catch (Exception e) {
            System.debug('Exception in Freshdesk search: ' + e.getMessage());
            return new List<String>();
        }
    }
}

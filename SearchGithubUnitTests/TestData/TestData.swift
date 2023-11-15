//
//  TestData.swift
//  SearchGithubUnitTests
//
//  Created by Nicolas Nshuti on 14/11/2023.
//

import Foundation

struct TestData {
    static let mockGitUsers = """
        [
            {
                "login": "zhings",
                "id": 2985134,
                "node_id": "MDQ6VXNlcjI5ODUxMzQ=",
                "avatar_url": "https://avatars.githubusercontent.com/u/2985134?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/zhings",
                "html_url": "https://github.com/zhings",
                "followers_url": "https://api.github.com/users/zhings/followers",
                "following_url": "https://api.github.com/users/zhings/following{/other_user}",
                "gists_url": "https://api.github.com/users/zhings/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/zhings/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/zhings/subscriptions",
                "organizations_url": "https://api.github.com/users/zhings/orgs",
                "repos_url": "https://api.github.com/users/zhings/repos",
                "events_url": "https://api.github.com/users/zhings/events{/privacy}",
                "received_events_url": "https://api.github.com/users/zhings/received_events",
                "type": "User",
                "site_admin": false
            },
            {
                "login": "ShinChven",
                "id": 3351486,
                "node_id": "MDQ6VXNlcjMzNTE0ODY=",
                "avatar_url": "https://avatars.githubusercontent.com/u/3351486?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/ShinChven",
                "html_url": "https://github.com/ShinChven",
                "followers_url": "https://api.github.com/users/ShinChven/followers",
                "following_url": "https://api.github.com/users/ShinChven/following{/other_user}",
                "gists_url": "https://api.github.com/users/ShinChven/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/ShinChven/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/ShinChven/subscriptions",
                "organizations_url": "https://api.github.com/users/ShinChven/orgs",
                "repos_url": "https://api.github.com/users/ShinChven/repos",
                "events_url": "https://api.github.com/users/ShinChven/events{/privacy}",
                "received_events_url": "https://api.github.com/users/ShinChven/received_events",
                "type": "User",
                "site_admin": false
            },
            {
                "login": "newmizanur",
                "id": 3446803,
                "node_id": "MDQ6VXNlcjM0NDY4MDM=",
                "avatar_url": "https://avatars.githubusercontent.com/u/3446803?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/newmizanur",
                "html_url": "https://github.com/newmizanur",
                "followers_url": "https://api.github.com/users/newmizanur/followers",
                "following_url": "https://api.github.com/users/newmizanur/following{/other_user}",
                "gists_url": "https://api.github.com/users/newmizanur/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/newmizanur/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/newmizanur/subscriptions",
                "organizations_url": "https://api.github.com/users/newmizanur/orgs",
                "repos_url": "https://api.github.com/users/newmizanur/repos",
                "events_url": "https://api.github.com/users/newmizanur/events{/privacy}",
                "received_events_url": "https://api.github.com/users/newmizanur/received_events",
                "type": "User",
                "site_admin": false
            },
            {
                "login": "S00F",
                "id": 3578014,
                "node_id": "MDQ6VXNlcjM1NzgwMTQ=",
                "avatar_url": "https://avatars.githubusercontent.com/u/3578014?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/S00F",
                "html_url": "https://github.com/S00F",
                "followers_url": "https://api.github.com/users/S00F/followers",
                "following_url": "https://api.github.com/users/S00F/following{/other_user}",
                "gists_url": "https://api.github.com/users/S00F/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/S00F/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/S00F/subscriptions",
                "organizations_url": "https://api.github.com/users/S00F/orgs",
                "repos_url": "https://api.github.com/users/S00F/repos",
                "events_url": "https://api.github.com/users/S00F/events{/privacy}",
                "received_events_url": "https://api.github.com/users/S00F/received_events",
                "type": "User",
                "site_admin": false
            },
            {
                "login": "techexpert0119",
                "id": 4477152,
                "node_id": "MDQ6VXNlcjQ0NzcxNTI=",
                "avatar_url": "https://avatars.githubusercontent.com/u/4477152?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/techexpert0119",
                "html_url": "https://github.com/techexpert0119",
                "followers_url": "https://api.github.com/users/techexpert0119/followers",
                "following_url": "https://api.github.com/users/techexpert0119/following{/other_user}",
                "gists_url": "https://api.github.com/users/techexpert0119/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/techexpert0119/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/techexpert0119/subscriptions",
                "organizations_url": "https://api.github.com/users/techexpert0119/orgs",
                "repos_url": "https://api.github.com/users/techexpert0119/repos",
                "events_url": "https://api.github.com/users/techexpert0119/events{/privacy}",
                "received_events_url": "https://api.github.com/users/techexpert0119/received_events",
                "type": "User",
                "site_admin": false
            }
        ]
    """.data(using: .utf8)
    
    static let invalidGitUsers = """
        [
            {
                "id": 4477152,
                "node_id": "MDQ6VXNlcjQ0NzcxNTI=",
                "gravatar_id": "",
                "url": "https://api.github.com/users/techexpert0119",
            }
        ]
    """.data(using: .utf8)
}

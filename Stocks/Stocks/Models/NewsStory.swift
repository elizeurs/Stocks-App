//
//  NewsStory.swift
//  Stocks
//
//  Created by Elizeu RS on 09/11/22.
//

import Foundation

/// Represent news story
struct NewsStory: Codable {
  let category: String
  let datetime: TimeInterval
  let headline: String
  let image: String
  let related: String
  let source: String
  let summary: String
  let url: String
}



//[
//  {
//    "category": "technology",
//    "datetime": 1596589501,
//    "headline": "Square surges after reporting 64% jump in revenue, more customers using Cash App",
//    "id": 5085164,
//    "image": "https://image.cnbcfm.com/api/v1/image/105569283-1542050972462rts25mct.jpg?v=1542051069",
//    "related": "",
//    "source": "CNBC",
//    "summary": "Shares of Square soared on Tuesday evening after posting better-than-expected quarterly results and strong growth in its consumer payments app.",
//    "url": "https://www.cnbc.com/2020/08/04/square-sq-earnings-q2-2020.html"
//  },
//  {
//    "category": "business",
//    "datetime": 1596588232,
//    "headline": "B&G Foods CEO expects pantry demand to hold up post-pandemic",
//    "id": 5085113,
//    "image": "https://image.cnbcfm.com/api/v1/image/106629991-1595532157669-gettyimages-1221952946-362857076_1-5.jpeg?v=1595532242",
//    "related": "",
//    "source": "CNBC",
//    "summary": "\"I think post-Covid, people will be working more at home, which means people will be eating more breakfast\" and other meals at home, B&G CEO Ken Romanzi said.",
//    "url": "https://www.cnbc.com/2020/08/04/bg-foods-ceo-expects-pantry-demand-to-hold-up-post-pandemic.html"
//  },
//  {
//    "category": "top news",
//    "datetime": 1596584406,
//    "headline": "Anthony Levandowski gets 18 months in prison for stealing Google self-driving car files",
//    "id": 5084850,
//    "image": "https://image.cnbcfm.com/api/v1/image/106648265-1596584130509-UBER-LEVANDOWSKI.JPG?v=1596584247",
//    "related": "",
//    "source": "CNBC",
//    "summary": "A U.S. judge on Tuesday sentenced former Google engineer Anthony Levandowski to 18 months in prison for stealing a trade secret from Google related to self-driving cars months before becoming the head of Uber Technologies Inc's rival unit.",
//    "url": "https://www.cnbc.com/2020/08/04/anthony-levandowski-gets-18-months-in-prison-for-stealing-google-self-driving-car-files.html"
//  }
//  }]



//https://finnhub.io/api/v1/news?category=general&token=cdkip12ad3idmsqf0t5gcdkip12ad3idmsqf0t60
//
//success([Stocks.NewsStory(category: "business", datetime: 1668032741.0, headline: "Major League Pickleball merges with PPA\'s week-old VIBE League", image: "https://image.cnbcfm.com/api/v1/image/107149332-1668031774753-gettyimages-1434129100-em3_6546_081e0791-7857-47bc-9d01-1061b07be1ff.jpeg?v=1668032741&w=1920&h=1080", related: "", source: "CNBC", summary: "Major League Pickleball, which boasts owners such as LeBron James, will merge with the week-old VIBE Pickleball League.", url: "https://www.cnbc.com/2022/11/09/major-league-pickleball-merges-with-ppa-vibe-league.html"), Stocks.NewsStory(category: "top news", datetime: 1668032530.0, headline: "Inflation, a regime shift", image: "https://data.bloomberglp.com/company/sites/2/2019/01/logobbg-wht.png", related: "", source: "Bloomberg", summary: "Since the COVID crisis that started in January 2020, the world economy has experienced increasing inflation pressures.", url: "https://www.bloomberg.com/professional/blog/inflation-a-regime-shift/")

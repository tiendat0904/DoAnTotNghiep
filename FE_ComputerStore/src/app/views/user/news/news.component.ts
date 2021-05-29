import { Component, OnInit } from '@angular/core';
import { LoaderService } from '../../../loader/loader.service';
import { newsModel } from '../../../models/news-model';
import { NewsService } from '../../../services/news/news.service';
declare var $: any;

@Component({
  selector: 'app-news',
  templateUrl: './news.component.html',
  styleUrls: ['./news.component.scss']
})
export class NewsComponent implements OnInit {

  list_news: Array<newsModel> = [];
  page = 1;
  pageSize = 8;
  constructor(private newService: NewsService, public loaderService: LoaderService) { }

  ngOnInit(): void {
    this.fetchNews();
    
  }

  fetchNews() {
    this.newService.getAll().subscribe(data => {
      this.list_news = data.data;
      this.list_news.sort(function (a, b) {
        return b.news_id - a.news_id;
      });
    })
  }
}

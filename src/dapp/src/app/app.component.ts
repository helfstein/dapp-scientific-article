import { Component } from '@angular/core';
import { EthService } from './eth.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'dapp';
  resultado: string;
  issn = '';
  author = '';

  constructor(private ethcontractService: EthService) {
    this.ethcontractService.result.subscribe(result => {
      this.resultado = JSON.stringify(result);
    });
  }

  publishArticle(event) {
    this.ethcontractService.publishArticle(this.issn, this.author).then(function(status) {
      console.log(status);
      this.initDisplay();
    }).catch(function(error) {
      console.log(error);
    });
  }
}

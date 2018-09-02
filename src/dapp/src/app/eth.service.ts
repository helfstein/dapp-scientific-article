import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

import * as Web3 from 'web3';
import * as TruffleContract from 'truffle-contract';

declare let require: any;
declare let window: any;
declare let web3: any;

const tokenAbi = require('../../../build/contracts/ArticleContract.json');

@Injectable({
  providedIn: 'root'
})
export class EthService {

  private web3Provider: null;
  private contract: TruffleContract;

  public result: BehaviorSubject<string> = new BehaviorSubject<string>('');

  constructor() {

    if (typeof window.web3 !== 'undefined') {
      this.web3Provider = window.web3.currentProvider;
    } else {
      this.web3Provider = new Web3['providers'].HttpProvider('http://localhost:7545');
    }
    const TWeb3: any = Web3;
    window.web3 = new TWeb3(this.web3Provider);
    this.contract = TruffleContract(tokenAbi);
    this.contract.setProvider(this.web3Provider);
    const self = this;
    this.contract.deployed().then(instance => {

      const ArticleResponse: any = instance.ArticleResponse({}, {fromBlock: 0, toBlock: 'latest'});

      ArticleResponse.watch((err, result) => {
        if (!err) {
          const res: string = result.args.result.toString();
          self.result.next(res);
        }
      });

    });
  }

  publishArticle(issn: string, author: string) {
    const self = this;
    return new Promise((resolve, reject) => {
      self.contract.deployed().then(instance => {
        return instance.publishArticle.send(issn, author);
      }).then(function(value) {
        if (value) {
          return resolve(value);
        }
      }).catch(function(error) {
        console.log(error);

        return reject('Error in transferEther service call');
      });
    });
  }
  }


}

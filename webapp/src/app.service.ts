import { Injectable } from '@nestjs/common';
import { Fabric } from './blockchain/fabric';

@Injectable()
export class AppService {
  public blockchain: Fabric;
  constructor() {
    this.blockchain = new Fabric();
  }

  public async query(): Promise<any> {
    return this.blockchain.query('get', 'key1');
  }

  public async invoke(): Promise<any> {
    return this.blockchain.invoke('set', 'key1', 'value1');
  }
}

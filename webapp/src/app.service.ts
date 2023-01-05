import { Injectable } from '@nestjs/common';
import { Fabric } from './blockchain/fabric';

@Injectable()
export class AppService {
  public blockchain: Fabric;
  constructor() {
    this.blockchain = new Fabric();
  }

  public async query(func: string, args: any): Promise<any> {
    return this.blockchain.query(func, ...args);
  }

  public async invoke(func: string, args: any): Promise<any> {
    return this.blockchain.invoke(func, ...args);
  }
}

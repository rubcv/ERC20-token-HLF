import { Injectable } from '@nestjs/common';
import { Fabric } from './blockchain/fabric';

@Injectable()
export class AppService {
  public blockchain: any;

  constructor() {
    this.blockchain = new Fabric();
  }

  getHello(): string {
    return 'Hello World!';
  }

  invoke(): any {
    return 'result';
  }
}

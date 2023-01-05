import { Body, Controller, Get, Post } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/query')
  public async Query(@Body() body: any): Promise<any> {
    const response = await this.appService.query(body.function, body.args);
    return { payload: response };
  }

  @Post('/invoke')
  public async Invoke(@Body() body: any): Promise<any> {
    const response = await this.appService.invoke(body.function, body.args);
    return { payload: response };
  }
}

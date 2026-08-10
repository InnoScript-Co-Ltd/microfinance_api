import { Global, Module } from '@nestjs/common';
import { SnowflakeId } from '../../common/helpers/helper.snowflake';
import { SnowflakeService } from './snowflake.service';

@Global()
@Module({
  providers: [SnowflakeId],
  exports: [SnowflakeService],
})
export class SnowflakeModule {}

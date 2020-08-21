//
//  JKADServiceRegisterDefines.h
//  runtime_section
//
//  Created by 刘威振 on 2020/8/14.
//  Copyright © 2020 大刘. All rights reserved.
//

#ifndef JKADServiceRegisterDefines_h
#define JKADServiceRegisterDefines_h

#define JKADServiceSectName "JKADServices"
#define JKADDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))

#define JKADServiceRegist(servicename) \
        char * k##servicename##_service JKADDATA(JKADServices) = ""#servicename"";\

// char *kJKADServices_service __attribute((used, section("__DATA","JKADServices"))) = "JKADServices";
// 把 JKADServices 放入section __DATA中, sectionName为JKADServices

//__attribute__((used,section...)) 用于把变量放入自定义section中, 比如:
//char *kTest __attribute((used, section("__DATA, custom_section_name"))) = "i/m test";
//表示"i/m test"放入名字为custom_section_name的区(section)中
//http://gcc.gnu.org/onlinedocs/gcc-3.2/gcc/Variable-Attributes.html

#endif /* JKADServiceRegisterDefines_h */


_date:     file format elf32-i386


Disassembly of section .text:

00000000 <dayofweek>:
static char *days[] = {"Sun", "Mon", "Tue", "Wed",
  "Thu", "Fri", "Sat"};

int
dayofweek(int y, int m, int d)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
   4:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
   8:	7f 0b                	jg     15 <dayofweek+0x15>
   a:	8b 45 08             	mov    0x8(%ebp),%eax
   d:	8d 50 ff             	lea    -0x1(%eax),%edx
  10:	89 55 08             	mov    %edx,0x8(%ebp)
  13:	eb 06                	jmp    1b <dayofweek+0x1b>
  15:	8b 45 08             	mov    0x8(%ebp),%eax
  18:	83 e8 02             	sub    $0x2,%eax
  1b:	01 45 10             	add    %eax,0x10(%ebp)
  1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  21:	6b c8 17             	imul   $0x17,%eax,%ecx
  24:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
  29:	89 c8                	mov    %ecx,%eax
  2b:	f7 ea                	imul   %edx
  2d:	d1 fa                	sar    %edx
  2f:	89 c8                	mov    %ecx,%eax
  31:	c1 f8 1f             	sar    $0x1f,%eax
  34:	29 c2                	sub    %eax,%edx
  36:	8b 45 10             	mov    0x10(%ebp),%eax
  39:	01 d0                	add    %edx,%eax
  3b:	8d 48 04             	lea    0x4(%eax),%ecx
  3e:	8b 45 08             	mov    0x8(%ebp),%eax
  41:	8d 50 03             	lea    0x3(%eax),%edx
  44:	85 c0                	test   %eax,%eax
  46:	0f 48 c2             	cmovs  %edx,%eax
  49:	c1 f8 02             	sar    $0x2,%eax
  4c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
  4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  52:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  57:	89 c8                	mov    %ecx,%eax
  59:	f7 ea                	imul   %edx
  5b:	c1 fa 05             	sar    $0x5,%edx
  5e:	89 c8                	mov    %ecx,%eax
  60:	c1 f8 1f             	sar    $0x1f,%eax
  63:	29 c2                	sub    %eax,%edx
  65:	89 d0                	mov    %edx,%eax
  67:	29 c3                	sub    %eax,%ebx
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  71:	89 c8                	mov    %ecx,%eax
  73:	f7 ea                	imul   %edx
  75:	c1 fa 07             	sar    $0x7,%edx
  78:	89 c8                	mov    %ecx,%eax
  7a:	c1 f8 1f             	sar    $0x1f,%eax
  7d:	29 c2                	sub    %eax,%edx
  7f:	89 d0                	mov    %edx,%eax
  81:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  84:	ba 93 24 49 92       	mov    $0x92492493,%edx
  89:	89 c8                	mov    %ecx,%eax
  8b:	f7 ea                	imul   %edx
  8d:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  90:	c1 f8 02             	sar    $0x2,%eax
  93:	89 c2                	mov    %eax,%edx
  95:	89 c8                	mov    %ecx,%eax
  97:	c1 f8 1f             	sar    $0x1f,%eax
  9a:	29 c2                	sub    %eax,%edx
  9c:	89 d0                	mov    %edx,%eax
  9e:	89 c2                	mov    %eax,%edx
  a0:	c1 e2 03             	shl    $0x3,%edx
  a3:	29 c2                	sub    %eax,%edx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	29 d0                	sub    %edx,%eax
}
  a9:	5b                   	pop    %ebx
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <main>:

int
main(int argc, char *argv[])
{
  ac:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  b0:	83 e4 f0             	and    $0xfffffff0,%esp
  b3:	ff 71 fc             	pushl  -0x4(%ecx)
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	51                   	push   %ecx
  ba:	83 ec 24             	sub    $0x24,%esp
  int day;
  struct rtcdate r;

  if (date(&r)) {
  bd:	83 ec 0c             	sub    $0xc,%esp
  c0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	e8 e6 04 00 00       	call   5af <date>
  c9:	83 c4 10             	add    $0x10,%esp
  cc:	85 c0                	test   %eax,%eax
  ce:	74 1b                	je     eb <main+0x3f>
    printf(2,"Error: date call failed. %s at line %d\n",
  d0:	6a 1c                	push   $0x1c
  d2:	68 95 0a 00 00       	push   $0xa95
  d7:	68 9c 0a 00 00       	push   $0xa9c
  dc:	6a 02                	push   $0x2
  de:	e8 ab 05 00 00       	call   68e <printf>
  e3:	83 c4 10             	add    $0x10,%esp
	__FILE__, __LINE__);
    exit();
  e6:	e8 1c 04 00 00       	call   507 <exit>
  }

  day = dayofweek(r.year, r.month, r.day);
  eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ee:	89 c1                	mov    %eax,%ecx
  f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  f3:	89 c2                	mov    %eax,%edx
  f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f8:	83 ec 04             	sub    $0x4,%esp
  fb:	51                   	push   %ecx
  fc:	52                   	push   %edx
  fd:	50                   	push   %eax
  fe:	e8 fd fe ff ff       	call   0 <dayofweek>
 103:	83 c4 10             	add    $0x10,%esp
 106:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "%s %s %d", days[day], months[r.month], r.day);
 109:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 10c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 10f:	8b 14 85 80 0d 00 00 	mov    0xd80(,%eax,4),%edx
 116:	8b 45 f4             	mov    -0xc(%ebp),%eax
 119:	8b 04 85 b4 0d 00 00 	mov    0xdb4(,%eax,4),%eax
 120:	83 ec 0c             	sub    $0xc,%esp
 123:	51                   	push   %ecx
 124:	52                   	push   %edx
 125:	50                   	push   %eax
 126:	68 c4 0a 00 00       	push   $0xac4
 12b:	6a 01                	push   $0x1
 12d:	e8 5c 05 00 00       	call   68e <printf>
 132:	83 c4 20             	add    $0x20,%esp
  printf(1, " ");
 135:	83 ec 08             	sub    $0x8,%esp
 138:	68 cd 0a 00 00       	push   $0xacd
 13d:	6a 01                	push   $0x1
 13f:	e8 4a 05 00 00       	call   68e <printf>
 144:	83 c4 10             	add    $0x10,%esp
  if (r.hour < 10) printf(1, "0");
 147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 14a:	83 f8 09             	cmp    $0x9,%eax
 14d:	77 12                	ja     161 <main+0xb5>
 14f:	83 ec 08             	sub    $0x8,%esp
 152:	68 cf 0a 00 00       	push   $0xacf
 157:	6a 01                	push   $0x1
 159:	e8 30 05 00 00       	call   68e <printf>
 15e:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d:", r.hour);
 161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 164:	83 ec 04             	sub    $0x4,%esp
 167:	50                   	push   %eax
 168:	68 d1 0a 00 00       	push   $0xad1
 16d:	6a 01                	push   $0x1
 16f:	e8 1a 05 00 00       	call   68e <printf>
 174:	83 c4 10             	add    $0x10,%esp
  if (r.minute < 10) printf(1, "0");
 177:	8b 45 e0             	mov    -0x20(%ebp),%eax
 17a:	83 f8 09             	cmp    $0x9,%eax
 17d:	77 12                	ja     191 <main+0xe5>
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	68 cf 0a 00 00       	push   $0xacf
 187:	6a 01                	push   $0x1
 189:	e8 00 05 00 00       	call   68e <printf>
 18e:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d:", r.minute);
 191:	8b 45 e0             	mov    -0x20(%ebp),%eax
 194:	83 ec 04             	sub    $0x4,%esp
 197:	50                   	push   %eax
 198:	68 d1 0a 00 00       	push   $0xad1
 19d:	6a 01                	push   $0x1
 19f:	e8 ea 04 00 00       	call   68e <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
  if (r.second < 10) printf(1, "0");
 1a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1aa:	83 f8 09             	cmp    $0x9,%eax
 1ad:	77 12                	ja     1c1 <main+0x115>
 1af:	83 ec 08             	sub    $0x8,%esp
 1b2:	68 cf 0a 00 00       	push   $0xacf
 1b7:	6a 01                	push   $0x1
 1b9:	e8 d0 04 00 00       	call   68e <printf>
 1be:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d UTC %d\n", r.second, r.year);
 1c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
 1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1c7:	52                   	push   %edx
 1c8:	50                   	push   %eax
 1c9:	68 d5 0a 00 00       	push   $0xad5
 1ce:	6a 01                	push   $0x1
 1d0:	e8 b9 04 00 00       	call   68e <printf>
 1d5:	83 c4 10             	add    $0x10,%esp

  exit();
 1d8:	e8 2a 03 00 00       	call   507 <exit>

000001dd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	57                   	push   %edi
 1e1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e5:	8b 55 10             	mov    0x10(%ebp),%edx
 1e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1eb:	89 cb                	mov    %ecx,%ebx
 1ed:	89 df                	mov    %ebx,%edi
 1ef:	89 d1                	mov    %edx,%ecx
 1f1:	fc                   	cld    
 1f2:	f3 aa                	rep stos %al,%es:(%edi)
 1f4:	89 ca                	mov    %ecx,%edx
 1f6:	89 fb                	mov    %edi,%ebx
 1f8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1fb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fe:	90                   	nop
 1ff:	5b                   	pop    %ebx
 200:	5f                   	pop    %edi
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    

00000203 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 20f:	90                   	nop
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8d 50 01             	lea    0x1(%eax),%edx
 216:	89 55 08             	mov    %edx,0x8(%ebp)
 219:	8b 55 0c             	mov    0xc(%ebp),%edx
 21c:	8d 4a 01             	lea    0x1(%edx),%ecx
 21f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 222:	0f b6 12             	movzbl (%edx),%edx
 225:	88 10                	mov    %dl,(%eax)
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	84 c0                	test   %al,%al
 22c:	75 e2                	jne    210 <strcpy+0xd>
    ;
  return os;
 22e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 236:	eb 08                	jmp    240 <strcmp+0xd>
    p++, q++;
 238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	84 c0                	test   %al,%al
 248:	74 10                	je     25a <strcmp+0x27>
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 10             	movzbl (%eax),%edx
 250:	8b 45 0c             	mov    0xc(%ebp),%eax
 253:	0f b6 00             	movzbl (%eax),%eax
 256:	38 c2                	cmp    %al,%dl
 258:	74 de                	je     238 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f b6 d0             	movzbl %al,%edx
 263:	8b 45 0c             	mov    0xc(%ebp),%eax
 266:	0f b6 00             	movzbl (%eax),%eax
 269:	0f b6 c0             	movzbl %al,%eax
 26c:	29 c2                	sub    %eax,%edx
 26e:	89 d0                	mov    %edx,%eax
}
 270:	5d                   	pop    %ebp
 271:	c3                   	ret    

00000272 <strlen>:

uint
strlen(char *s)
{
 272:	55                   	push   %ebp
 273:	89 e5                	mov    %esp,%ebp
 275:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 278:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 27f:	eb 04                	jmp    285 <strlen+0x13>
 281:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 285:	8b 55 fc             	mov    -0x4(%ebp),%edx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	01 d0                	add    %edx,%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	84 c0                	test   %al,%al
 292:	75 ed                	jne    281 <strlen+0xf>
    ;
  return n;
 294:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 297:	c9                   	leave  
 298:	c3                   	ret    

00000299 <memset>:

void*
memset(void *dst, int c, uint n)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 29c:	8b 45 10             	mov    0x10(%ebp),%eax
 29f:	50                   	push   %eax
 2a0:	ff 75 0c             	pushl  0xc(%ebp)
 2a3:	ff 75 08             	pushl  0x8(%ebp)
 2a6:	e8 32 ff ff ff       	call   1dd <stosb>
 2ab:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b1:	c9                   	leave  
 2b2:	c3                   	ret    

000002b3 <strchr>:

char*
strchr(const char *s, char c)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	83 ec 04             	sub    $0x4,%esp
 2b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2bf:	eb 14                	jmp    2d5 <strchr+0x22>
    if(*s == c)
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2ca:	75 05                	jne    2d1 <strchr+0x1e>
      return (char*)s;
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	eb 13                	jmp    2e4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2d1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	84 c0                	test   %al,%al
 2dd:	75 e2                	jne    2c1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2df:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <gets>:

char*
gets(char *buf, int max)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2f3:	eb 42                	jmp    337 <gets+0x51>
    cc = read(0, &c, 1);
 2f5:	83 ec 04             	sub    $0x4,%esp
 2f8:	6a 01                	push   $0x1
 2fa:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2fd:	50                   	push   %eax
 2fe:	6a 00                	push   $0x0
 300:	e8 1a 02 00 00       	call   51f <read>
 305:	83 c4 10             	add    $0x10,%esp
 308:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 30b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30f:	7e 33                	jle    344 <gets+0x5e>
      break;
    buf[i++] = c;
 311:	8b 45 f4             	mov    -0xc(%ebp),%eax
 314:	8d 50 01             	lea    0x1(%eax),%edx
 317:	89 55 f4             	mov    %edx,-0xc(%ebp)
 31a:	89 c2                	mov    %eax,%edx
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	01 c2                	add    %eax,%edx
 321:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 325:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 327:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32b:	3c 0a                	cmp    $0xa,%al
 32d:	74 16                	je     345 <gets+0x5f>
 32f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 333:	3c 0d                	cmp    $0xd,%al
 335:	74 0e                	je     345 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 337:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33a:	83 c0 01             	add    $0x1,%eax
 33d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 340:	7c b3                	jl     2f5 <gets+0xf>
 342:	eb 01                	jmp    345 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 344:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 345:	8b 55 f4             	mov    -0xc(%ebp),%edx
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	01 d0                	add    %edx,%eax
 34d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <stat>:

int
stat(char *n, struct stat *st)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	6a 00                	push   $0x0
 360:	ff 75 08             	pushl  0x8(%ebp)
 363:	e8 df 01 00 00       	call   547 <open>
 368:	83 c4 10             	add    $0x10,%esp
 36b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 36e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 372:	79 07                	jns    37b <stat+0x26>
    return -1;
 374:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 379:	eb 25                	jmp    3a0 <stat+0x4b>
  r = fstat(fd, st);
 37b:	83 ec 08             	sub    $0x8,%esp
 37e:	ff 75 0c             	pushl  0xc(%ebp)
 381:	ff 75 f4             	pushl  -0xc(%ebp)
 384:	e8 d6 01 00 00       	call   55f <fstat>
 389:	83 c4 10             	add    $0x10,%esp
 38c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 38f:	83 ec 0c             	sub    $0xc,%esp
 392:	ff 75 f4             	pushl  -0xc(%ebp)
 395:	e8 95 01 00 00       	call   52f <close>
 39a:	83 c4 10             	add    $0x10,%esp
  return r;
 39d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    

000003a2 <atoi>:

int
atoi(const char *s)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3af:	eb 04                	jmp    3b5 <atoi+0x13>
 3b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b5:	8b 45 08             	mov    0x8(%ebp),%eax
 3b8:	0f b6 00             	movzbl (%eax),%eax
 3bb:	3c 20                	cmp    $0x20,%al
 3bd:	74 f2                	je     3b1 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	3c 2d                	cmp    $0x2d,%al
 3c7:	75 07                	jne    3d0 <atoi+0x2e>
 3c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ce:	eb 05                	jmp    3d5 <atoi+0x33>
 3d0:	b8 01 00 00 00       	mov    $0x1,%eax
 3d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	3c 2b                	cmp    $0x2b,%al
 3e0:	74 0a                	je     3ec <atoi+0x4a>
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	0f b6 00             	movzbl (%eax),%eax
 3e8:	3c 2d                	cmp    $0x2d,%al
 3ea:	75 2b                	jne    417 <atoi+0x75>
    s++;
 3ec:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3f0:	eb 25                	jmp    417 <atoi+0x75>
    n = n*10 + *s++ - '0';
 3f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f5:	89 d0                	mov    %edx,%eax
 3f7:	c1 e0 02             	shl    $0x2,%eax
 3fa:	01 d0                	add    %edx,%eax
 3fc:	01 c0                	add    %eax,%eax
 3fe:	89 c1                	mov    %eax,%ecx
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	8d 50 01             	lea    0x1(%eax),%edx
 406:	89 55 08             	mov    %edx,0x8(%ebp)
 409:	0f b6 00             	movzbl (%eax),%eax
 40c:	0f be c0             	movsbl %al,%eax
 40f:	01 c8                	add    %ecx,%eax
 411:	83 e8 30             	sub    $0x30,%eax
 414:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	0f b6 00             	movzbl (%eax),%eax
 41d:	3c 2f                	cmp    $0x2f,%al
 41f:	7e 0a                	jle    42b <atoi+0x89>
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	0f b6 00             	movzbl (%eax),%eax
 427:	3c 39                	cmp    $0x39,%al
 429:	7e c7                	jle    3f2 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 42b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 42e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <atoo>:

int
atoo(const char *s)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 43a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 441:	eb 04                	jmp    447 <atoo+0x13>
 443:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	0f b6 00             	movzbl (%eax),%eax
 44d:	3c 20                	cmp    $0x20,%al
 44f:	74 f2                	je     443 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 451:	8b 45 08             	mov    0x8(%ebp),%eax
 454:	0f b6 00             	movzbl (%eax),%eax
 457:	3c 2d                	cmp    $0x2d,%al
 459:	75 07                	jne    462 <atoo+0x2e>
 45b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 460:	eb 05                	jmp    467 <atoo+0x33>
 462:	b8 01 00 00 00       	mov    $0x1,%eax
 467:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	0f b6 00             	movzbl (%eax),%eax
 470:	3c 2b                	cmp    $0x2b,%al
 472:	74 0a                	je     47e <atoo+0x4a>
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	0f b6 00             	movzbl (%eax),%eax
 47a:	3c 2d                	cmp    $0x2d,%al
 47c:	75 27                	jne    4a5 <atoo+0x71>
    s++;
 47e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 482:	eb 21                	jmp    4a5 <atoo+0x71>
    n = n*8 + *s++ - '0';
 484:	8b 45 fc             	mov    -0x4(%ebp),%eax
 487:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 48e:	8b 45 08             	mov    0x8(%ebp),%eax
 491:	8d 50 01             	lea    0x1(%eax),%edx
 494:	89 55 08             	mov    %edx,0x8(%ebp)
 497:	0f b6 00             	movzbl (%eax),%eax
 49a:	0f be c0             	movsbl %al,%eax
 49d:	01 c8                	add    %ecx,%eax
 49f:	83 e8 30             	sub    $0x30,%eax
 4a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	0f b6 00             	movzbl (%eax),%eax
 4ab:	3c 2f                	cmp    $0x2f,%al
 4ad:	7e 0a                	jle    4b9 <atoo+0x85>
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	3c 37                	cmp    $0x37,%al
 4b7:	7e cb                	jle    484 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 4b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4bc:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4c0:	c9                   	leave  
 4c1:	c3                   	ret    

000004c2 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 4c2:	55                   	push   %ebp
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4d4:	eb 17                	jmp    4ed <memmove+0x2b>
    *dst++ = *src++;
 4d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4d9:	8d 50 01             	lea    0x1(%eax),%edx
 4dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4df:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4e2:	8d 4a 01             	lea    0x1(%edx),%ecx
 4e5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4e8:	0f b6 12             	movzbl (%edx),%edx
 4eb:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ed:	8b 45 10             	mov    0x10(%ebp),%eax
 4f0:	8d 50 ff             	lea    -0x1(%eax),%edx
 4f3:	89 55 10             	mov    %edx,0x10(%ebp)
 4f6:	85 c0                	test   %eax,%eax
 4f8:	7f dc                	jg     4d6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4fd:	c9                   	leave  
 4fe:	c3                   	ret    

000004ff <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ff:	b8 01 00 00 00       	mov    $0x1,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <exit>:
SYSCALL(exit)
 507:	b8 02 00 00 00       	mov    $0x2,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <wait>:
SYSCALL(wait)
 50f:	b8 03 00 00 00       	mov    $0x3,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <pipe>:
SYSCALL(pipe)
 517:	b8 04 00 00 00       	mov    $0x4,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <read>:
SYSCALL(read)
 51f:	b8 05 00 00 00       	mov    $0x5,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <write>:
SYSCALL(write)
 527:	b8 10 00 00 00       	mov    $0x10,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <close>:
SYSCALL(close)
 52f:	b8 15 00 00 00       	mov    $0x15,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <kill>:
SYSCALL(kill)
 537:	b8 06 00 00 00       	mov    $0x6,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <exec>:
SYSCALL(exec)
 53f:	b8 07 00 00 00       	mov    $0x7,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <open>:
SYSCALL(open)
 547:	b8 0f 00 00 00       	mov    $0xf,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <mknod>:
SYSCALL(mknod)
 54f:	b8 11 00 00 00       	mov    $0x11,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <unlink>:
SYSCALL(unlink)
 557:	b8 12 00 00 00       	mov    $0x12,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <fstat>:
SYSCALL(fstat)
 55f:	b8 08 00 00 00       	mov    $0x8,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <link>:
SYSCALL(link)
 567:	b8 13 00 00 00       	mov    $0x13,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <mkdir>:
SYSCALL(mkdir)
 56f:	b8 14 00 00 00       	mov    $0x14,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <chdir>:
SYSCALL(chdir)
 577:	b8 09 00 00 00       	mov    $0x9,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <dup>:
SYSCALL(dup)
 57f:	b8 0a 00 00 00       	mov    $0xa,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <getpid>:
SYSCALL(getpid)
 587:	b8 0b 00 00 00       	mov    $0xb,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <sbrk>:
SYSCALL(sbrk)
 58f:	b8 0c 00 00 00       	mov    $0xc,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <sleep>:
SYSCALL(sleep)
 597:	b8 0d 00 00 00       	mov    $0xd,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <uptime>:
SYSCALL(uptime)
 59f:	b8 0e 00 00 00       	mov    $0xe,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <halt>:
SYSCALL(halt)
 5a7:	b8 16 00 00 00       	mov    $0x16,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <date>:
SYSCALL(date)
 5af:	b8 17 00 00 00       	mov    $0x17,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5b7:	55                   	push   %ebp
 5b8:	89 e5                	mov    %esp,%ebp
 5ba:	83 ec 18             	sub    $0x18,%esp
 5bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5c3:	83 ec 04             	sub    $0x4,%esp
 5c6:	6a 01                	push   $0x1
 5c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5cb:	50                   	push   %eax
 5cc:	ff 75 08             	pushl  0x8(%ebp)
 5cf:	e8 53 ff ff ff       	call   527 <write>
 5d4:	83 c4 10             	add    $0x10,%esp
}
 5d7:	90                   	nop
 5d8:	c9                   	leave  
 5d9:	c3                   	ret    

000005da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5da:	55                   	push   %ebp
 5db:	89 e5                	mov    %esp,%ebp
 5dd:	53                   	push   %ebx
 5de:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5e8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5ec:	74 17                	je     605 <printint+0x2b>
 5ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5f2:	79 11                	jns    605 <printint+0x2b>
    neg = 1;
 5f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fe:	f7 d8                	neg    %eax
 600:	89 45 ec             	mov    %eax,-0x14(%ebp)
 603:	eb 06                	jmp    60b <printint+0x31>
  } else {
    x = xx;
 605:	8b 45 0c             	mov    0xc(%ebp),%eax
 608:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 60b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 612:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 615:	8d 41 01             	lea    0x1(%ecx),%eax
 618:	89 45 f4             	mov    %eax,-0xc(%ebp)
 61b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 61e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 621:	ba 00 00 00 00       	mov    $0x0,%edx
 626:	f7 f3                	div    %ebx
 628:	89 d0                	mov    %edx,%eax
 62a:	0f b6 80 d0 0d 00 00 	movzbl 0xdd0(%eax),%eax
 631:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 635:	8b 5d 10             	mov    0x10(%ebp),%ebx
 638:	8b 45 ec             	mov    -0x14(%ebp),%eax
 63b:	ba 00 00 00 00       	mov    $0x0,%edx
 640:	f7 f3                	div    %ebx
 642:	89 45 ec             	mov    %eax,-0x14(%ebp)
 645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 649:	75 c7                	jne    612 <printint+0x38>
  if(neg)
 64b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 64f:	74 2d                	je     67e <printint+0xa4>
    buf[i++] = '-';
 651:	8b 45 f4             	mov    -0xc(%ebp),%eax
 654:	8d 50 01             	lea    0x1(%eax),%edx
 657:	89 55 f4             	mov    %edx,-0xc(%ebp)
 65a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 65f:	eb 1d                	jmp    67e <printint+0xa4>
    putc(fd, buf[i]);
 661:	8d 55 dc             	lea    -0x24(%ebp),%edx
 664:	8b 45 f4             	mov    -0xc(%ebp),%eax
 667:	01 d0                	add    %edx,%eax
 669:	0f b6 00             	movzbl (%eax),%eax
 66c:	0f be c0             	movsbl %al,%eax
 66f:	83 ec 08             	sub    $0x8,%esp
 672:	50                   	push   %eax
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 3c ff ff ff       	call   5b7 <putc>
 67b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 67e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 686:	79 d9                	jns    661 <printint+0x87>
    putc(fd, buf[i]);
}
 688:	90                   	nop
 689:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 68c:	c9                   	leave  
 68d:	c3                   	ret    

0000068e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 68e:	55                   	push   %ebp
 68f:	89 e5                	mov    %esp,%ebp
 691:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 694:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 69b:	8d 45 0c             	lea    0xc(%ebp),%eax
 69e:	83 c0 04             	add    $0x4,%eax
 6a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6ab:	e9 59 01 00 00       	jmp    809 <printf+0x17b>
    c = fmt[i] & 0xff;
 6b0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b6:	01 d0                	add    %edx,%eax
 6b8:	0f b6 00             	movzbl (%eax),%eax
 6bb:	0f be c0             	movsbl %al,%eax
 6be:	25 ff 00 00 00       	and    $0xff,%eax
 6c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6ca:	75 2c                	jne    6f8 <printf+0x6a>
      if(c == '%'){
 6cc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d0:	75 0c                	jne    6de <printf+0x50>
        state = '%';
 6d2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6d9:	e9 27 01 00 00       	jmp    805 <printf+0x177>
      } else {
        putc(fd, c);
 6de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	83 ec 08             	sub    $0x8,%esp
 6e7:	50                   	push   %eax
 6e8:	ff 75 08             	pushl  0x8(%ebp)
 6eb:	e8 c7 fe ff ff       	call   5b7 <putc>
 6f0:	83 c4 10             	add    $0x10,%esp
 6f3:	e9 0d 01 00 00       	jmp    805 <printf+0x177>
      }
    } else if(state == '%'){
 6f8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6fc:	0f 85 03 01 00 00    	jne    805 <printf+0x177>
      if(c == 'd'){
 702:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 706:	75 1e                	jne    726 <printf+0x98>
        printint(fd, *ap, 10, 1);
 708:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	6a 01                	push   $0x1
 70f:	6a 0a                	push   $0xa
 711:	50                   	push   %eax
 712:	ff 75 08             	pushl  0x8(%ebp)
 715:	e8 c0 fe ff ff       	call   5da <printint>
 71a:	83 c4 10             	add    $0x10,%esp
        ap++;
 71d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 721:	e9 d8 00 00 00       	jmp    7fe <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 726:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 72a:	74 06                	je     732 <printf+0xa4>
 72c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 730:	75 1e                	jne    750 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 732:	8b 45 e8             	mov    -0x18(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	6a 00                	push   $0x0
 739:	6a 10                	push   $0x10
 73b:	50                   	push   %eax
 73c:	ff 75 08             	pushl  0x8(%ebp)
 73f:	e8 96 fe ff ff       	call   5da <printint>
 744:	83 c4 10             	add    $0x10,%esp
        ap++;
 747:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74b:	e9 ae 00 00 00       	jmp    7fe <printf+0x170>
      } else if(c == 's'){
 750:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 754:	75 43                	jne    799 <printf+0x10b>
        s = (char*)*ap;
 756:	8b 45 e8             	mov    -0x18(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 75e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 766:	75 25                	jne    78d <printf+0xff>
          s = "(null)";
 768:	c7 45 f4 e0 0a 00 00 	movl   $0xae0,-0xc(%ebp)
        while(*s != 0){
 76f:	eb 1c                	jmp    78d <printf+0xff>
          putc(fd, *s);
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	0f b6 00             	movzbl (%eax),%eax
 777:	0f be c0             	movsbl %al,%eax
 77a:	83 ec 08             	sub    $0x8,%esp
 77d:	50                   	push   %eax
 77e:	ff 75 08             	pushl  0x8(%ebp)
 781:	e8 31 fe ff ff       	call   5b7 <putc>
 786:	83 c4 10             	add    $0x10,%esp
          s++;
 789:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	0f b6 00             	movzbl (%eax),%eax
 793:	84 c0                	test   %al,%al
 795:	75 da                	jne    771 <printf+0xe3>
 797:	eb 65                	jmp    7fe <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 799:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 79d:	75 1d                	jne    7bc <printf+0x12e>
        putc(fd, *ap);
 79f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	0f be c0             	movsbl %al,%eax
 7a7:	83 ec 08             	sub    $0x8,%esp
 7aa:	50                   	push   %eax
 7ab:	ff 75 08             	pushl  0x8(%ebp)
 7ae:	e8 04 fe ff ff       	call   5b7 <putc>
 7b3:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ba:	eb 42                	jmp    7fe <printf+0x170>
      } else if(c == '%'){
 7bc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c0:	75 17                	jne    7d9 <printf+0x14b>
        putc(fd, c);
 7c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7c5:	0f be c0             	movsbl %al,%eax
 7c8:	83 ec 08             	sub    $0x8,%esp
 7cb:	50                   	push   %eax
 7cc:	ff 75 08             	pushl  0x8(%ebp)
 7cf:	e8 e3 fd ff ff       	call   5b7 <putc>
 7d4:	83 c4 10             	add    $0x10,%esp
 7d7:	eb 25                	jmp    7fe <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7d9:	83 ec 08             	sub    $0x8,%esp
 7dc:	6a 25                	push   $0x25
 7de:	ff 75 08             	pushl  0x8(%ebp)
 7e1:	e8 d1 fd ff ff       	call   5b7 <putc>
 7e6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ec:	0f be c0             	movsbl %al,%eax
 7ef:	83 ec 08             	sub    $0x8,%esp
 7f2:	50                   	push   %eax
 7f3:	ff 75 08             	pushl  0x8(%ebp)
 7f6:	e8 bc fd ff ff       	call   5b7 <putc>
 7fb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 805:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 809:	8b 55 0c             	mov    0xc(%ebp),%edx
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	01 d0                	add    %edx,%eax
 811:	0f b6 00             	movzbl (%eax),%eax
 814:	84 c0                	test   %al,%al
 816:	0f 85 94 fe ff ff    	jne    6b0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 81c:	90                   	nop
 81d:	c9                   	leave  
 81e:	c3                   	ret    

0000081f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81f:	55                   	push   %ebp
 820:	89 e5                	mov    %esp,%ebp
 822:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 825:	8b 45 08             	mov    0x8(%ebp),%eax
 828:	83 e8 08             	sub    $0x8,%eax
 82b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82e:	a1 ec 0d 00 00       	mov    0xdec,%eax
 833:	89 45 fc             	mov    %eax,-0x4(%ebp)
 836:	eb 24                	jmp    85c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 840:	77 12                	ja     854 <free+0x35>
 842:	8b 45 f8             	mov    -0x8(%ebp),%eax
 845:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 848:	77 24                	ja     86e <free+0x4f>
 84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84d:	8b 00                	mov    (%eax),%eax
 84f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 852:	77 1a                	ja     86e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 fc             	mov    %eax,-0x4(%ebp)
 85c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 862:	76 d4                	jbe    838 <free+0x19>
 864:	8b 45 fc             	mov    -0x4(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 86c:	76 ca                	jbe    838 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 86e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 871:	8b 40 04             	mov    0x4(%eax),%eax
 874:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 87b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87e:	01 c2                	add    %eax,%edx
 880:	8b 45 fc             	mov    -0x4(%ebp),%eax
 883:	8b 00                	mov    (%eax),%eax
 885:	39 c2                	cmp    %eax,%edx
 887:	75 24                	jne    8ad <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 889:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88c:	8b 50 04             	mov    0x4(%eax),%edx
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	8b 40 04             	mov    0x4(%eax),%eax
 897:	01 c2                	add    %eax,%edx
 899:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 89f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a2:	8b 00                	mov    (%eax),%eax
 8a4:	8b 10                	mov    (%eax),%edx
 8a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a9:	89 10                	mov    %edx,(%eax)
 8ab:	eb 0a                	jmp    8b7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	8b 10                	mov    (%eax),%edx
 8b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c7:	01 d0                	add    %edx,%eax
 8c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8cc:	75 20                	jne    8ee <free+0xcf>
    p->s.size += bp->s.size;
 8ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d1:	8b 50 04             	mov    0x4(%eax),%edx
 8d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	01 c2                	add    %eax,%edx
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e5:	8b 10                	mov    (%eax),%edx
 8e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ea:	89 10                	mov    %edx,(%eax)
 8ec:	eb 08                	jmp    8f6 <free+0xd7>
  } else
    p->s.ptr = bp;
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8f4:	89 10                	mov    %edx,(%eax)
  freep = p;
 8f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f9:	a3 ec 0d 00 00       	mov    %eax,0xdec
}
 8fe:	90                   	nop
 8ff:	c9                   	leave  
 900:	c3                   	ret    

00000901 <morecore>:

static Header*
morecore(uint nu)
{
 901:	55                   	push   %ebp
 902:	89 e5                	mov    %esp,%ebp
 904:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 907:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 90e:	77 07                	ja     917 <morecore+0x16>
    nu = 4096;
 910:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 917:	8b 45 08             	mov    0x8(%ebp),%eax
 91a:	c1 e0 03             	shl    $0x3,%eax
 91d:	83 ec 0c             	sub    $0xc,%esp
 920:	50                   	push   %eax
 921:	e8 69 fc ff ff       	call   58f <sbrk>
 926:	83 c4 10             	add    $0x10,%esp
 929:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 92c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 930:	75 07                	jne    939 <morecore+0x38>
    return 0;
 932:	b8 00 00 00 00       	mov    $0x0,%eax
 937:	eb 26                	jmp    95f <morecore+0x5e>
  hp = (Header*)p;
 939:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 93f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 942:	8b 55 08             	mov    0x8(%ebp),%edx
 945:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 948:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94b:	83 c0 08             	add    $0x8,%eax
 94e:	83 ec 0c             	sub    $0xc,%esp
 951:	50                   	push   %eax
 952:	e8 c8 fe ff ff       	call   81f <free>
 957:	83 c4 10             	add    $0x10,%esp
  return freep;
 95a:	a1 ec 0d 00 00       	mov    0xdec,%eax
}
 95f:	c9                   	leave  
 960:	c3                   	ret    

00000961 <malloc>:

void*
malloc(uint nbytes)
{
 961:	55                   	push   %ebp
 962:	89 e5                	mov    %esp,%ebp
 964:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 967:	8b 45 08             	mov    0x8(%ebp),%eax
 96a:	83 c0 07             	add    $0x7,%eax
 96d:	c1 e8 03             	shr    $0x3,%eax
 970:	83 c0 01             	add    $0x1,%eax
 973:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 976:	a1 ec 0d 00 00       	mov    0xdec,%eax
 97b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 97e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 982:	75 23                	jne    9a7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 984:	c7 45 f0 e4 0d 00 00 	movl   $0xde4,-0x10(%ebp)
 98b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98e:	a3 ec 0d 00 00       	mov    %eax,0xdec
 993:	a1 ec 0d 00 00       	mov    0xdec,%eax
 998:	a3 e4 0d 00 00       	mov    %eax,0xde4
    base.s.size = 0;
 99d:	c7 05 e8 0d 00 00 00 	movl   $0x0,0xde8
 9a4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9aa:	8b 00                	mov    (%eax),%eax
 9ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b2:	8b 40 04             	mov    0x4(%eax),%eax
 9b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9b8:	72 4d                	jb     a07 <malloc+0xa6>
      if(p->s.size == nunits)
 9ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bd:	8b 40 04             	mov    0x4(%eax),%eax
 9c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9c3:	75 0c                	jne    9d1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	8b 10                	mov    (%eax),%edx
 9ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cd:	89 10                	mov    %edx,(%eax)
 9cf:	eb 26                	jmp    9f7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d4:	8b 40 04             	mov    0x4(%eax),%eax
 9d7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9da:	89 c2                	mov    %eax,%edx
 9dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9df:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e5:	8b 40 04             	mov    0x4(%eax),%eax
 9e8:	c1 e0 03             	shl    $0x3,%eax
 9eb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9f4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fa:	a3 ec 0d 00 00       	mov    %eax,0xdec
      return (void*)(p + 1);
 9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a02:	83 c0 08             	add    $0x8,%eax
 a05:	eb 3b                	jmp    a42 <malloc+0xe1>
    }
    if(p == freep)
 a07:	a1 ec 0d 00 00       	mov    0xdec,%eax
 a0c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a0f:	75 1e                	jne    a2f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a11:	83 ec 0c             	sub    $0xc,%esp
 a14:	ff 75 ec             	pushl  -0x14(%ebp)
 a17:	e8 e5 fe ff ff       	call   901 <morecore>
 a1c:	83 c4 10             	add    $0x10,%esp
 a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a26:	75 07                	jne    a2f <malloc+0xce>
        return 0;
 a28:	b8 00 00 00 00       	mov    $0x0,%eax
 a2d:	eb 13                	jmp    a42 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a38:	8b 00                	mov    (%eax),%eax
 a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a3d:	e9 6d ff ff ff       	jmp    9af <malloc+0x4e>
}
 a42:	c9                   	leave  
 a43:	c3                   	ret    

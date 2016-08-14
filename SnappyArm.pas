unit SnappyArm;

// Roberto Della Pasqua, for questions contact me through www.dellapasqua.com
// 8.aug.2016
// google snappy: ultra fast compression and decompression algorithm
// source compiled with bccaarm 7.20 and bccios 7.20
// tested md5 100% ok
// todo:
// -testing with memory mapped files
// -scatter/gather io on windows
// -waiting delphi dcc64linux for porting
//
// copyright snappy 1.1.3:
// https://google.github.io/snappy/
// C port https://github.com/andikleen/snappy-c

interface

type
  snappy_env = record
    hash_table: ^word;
    scratch: pointer;
    scratch_output: pointer;
  end;

  iovec = record
  end;

  Psnappy_env = ^snappy_env;
  Piovec = ^iovec;

{$IFDEF ANDROID}
const
  libname = 'snappyaa.o';
{$ENDIF}
{$IFDEF IOS}
const
  libname = 'snappyios.o';
{$ENDIF}

// snappy routines
function snappy_init_env(env: Psnappy_env): longint; cdecl; external ''+libname+'' name 'snappy_init_env';
procedure snappy_free_env(env: Psnappy_env); cdecl; external ''+libname+'' name 'snappy_free_env';
function snappy_uncompress(compressed: Pchar; n: NativeUInt; uncompressed: Pchar): longint; cdecl; external ''+libname+'' name 'snappy_uncompress';
function snappy_compress(env: Psnappy_env; input: Pchar; input_length: NativeUInt; compressed: Pchar; compressed_length: PNativeUInt): longint; cdecl;
  external ''+libname+'' name 'snappy_compress';
function snappy_uncompressed_length(buf: Pchar; len: NativeUInt; result: PNativeUInt): boolean; cdecl; external ''+libname+'' name 'snappy_uncompressed_length';
function snappy_max_compressed_length(source_len: NativeUInt): NativeUInt; cdecl; external ''+libname+'' name 'snappy_max_compressed_length';

// scatter-gather io implemented in linux uio.h
// function snappy_init_env_sg(env: Psnappy_env; sg: boolean): longint; cdecl; external;
// function snappy_compress_iov(env: Psnappy_env; iov_in: Piovec; iov_in_len: longint; input_length: NativeUInt; iov_out: Piovec; iov_out_len: Plongint; compressed_length: PNativeUInt): longint; cdecl; external;
// function snappy_uncompress_iov(iov_in: Piovec; iov_in_len: longint; input_len: NativeUInt; uncompressed: Pchar): longint; cdecl; external;

// c runtime routines
procedure _assert(__cond, __file: Pchar; __line: Integer); cdecl;
procedure free(P: pointer); cdecl;
function malloc(size: Integer): pointer; cdecl;
function memcmp(s1, s2: pointer; n: Integer): Integer; cdecl;
procedure memcpy(dest, source: pointer; count: Integer); cdecl;
function memmove(dest, src: pointer; n: Cardinal): pointer; cdecl;
procedure memset(P: pointer; B: Integer; count: Integer); cdecl;

const
  _LINUX_SNAPPY_H = 1;

implementation

uses SysUtils;

{$IFDEF ANDROID}
{$LINK 'snappyaa.o'}
{$ENDIF}
{$IFDEF IOS}
{$LINK 'snappyios.o'}
{$ENDIF}

procedure _assert(__cond, __file: Pchar; __line: Integer);
begin
  raise Exception.CreateFmt('Assertion failed: %s, file %s, line %d', [__cond, __file, __line]);
end;

procedure free(P: pointer);
begin
  FreeMem(P);
end;

function malloc(size: Integer): pointer;
begin
  GetMem(result, size);
end;

function memcmp(s1, s2: pointer; n: Integer): Integer;
begin
  result := StrLComp(PWideChar(s1), PWideChar(s2), n);
end;

procedure memcpy(dest, source: pointer; count: Integer);
begin
  Move(source^, dest^, count);
end;

function memmove(dest, src: pointer; n: Cardinal): pointer;
begin
  Move(src^, dest^, n);
  result := dest;
end;

procedure memset(P: pointer; B: Integer; count: Integer);
begin
  FillChar(P^, count, B);
end;

end.

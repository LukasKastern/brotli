const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const brotli_common = b.addStaticLibrary(.{
        .name = "brotlicommon",
        .target = target,
        .optimize = optimize,
    });

    brotli_common.addCSourceFiles(&.{
        "c/common/constants.c",
        "c/common/context.c",
        "c/common/dictionary.c",
        "c/common/platform.c",
        "c/common/shared_dictionary.c",
        "c/common/transform.c",
    }, &.{});

    brotli_common.addIncludePath("c/include");

    brotli_common.linkLibC();
    b.installArtifact(brotli_common);
    brotli_common.installHeadersDirectory("c/include/brotli", "brotli");

    const brotli_encoder = b.addStaticLibrary(.{
        .name = "brotliencoder",
        .target = target,
        .optimize = optimize,
    });

    brotli_encoder.addCSourceFiles(&.{
        "c/enc/backward_references.c",
        "c/enc/backward_references_hq.c",
        "c/enc/bit_cost.c",
        "c/enc/block_splitter.c",
        "c/enc/brotli_bit_stream.c",
        "c/enc/cluster.c",
        "c/enc/command.c",
        "c/enc/compound_dictionary.c",
        "c/enc/compress_fragment.c",
        "c/enc/compress_fragment_two_pass.c",
        "c/enc/dictionary_hash.c",
        "c/enc/encode.c",
        "c/enc/encoder_dict.c",
        "c/enc/entropy_encode.c",
        "c/enc/fast_log.c",
        "c/enc/histogram.c",
        "c/enc/literal_cost.c",
        "c/enc/memory.c",
        "c/enc/metablock.c",
        "c/enc/static_dict.c",
        "c/enc/utf8_util.c",
    }, &.{});

    brotli_encoder.addIncludePath("c/include");

    brotli_encoder.linkLibC();
    b.installArtifact(brotli_encoder);

    const brotli_dec = b.addStaticLibrary(.{
        .name = "brotlidec",
        .target = target,
        .optimize = optimize,
    });

    brotli_dec.addCSourceFiles(&.{
        "c/dec/bit_reader.c",
        "c/dec/decode.c",
        "c/dec/huffman.c",
        "c/dec/state.c",
    }, &.{});

    brotli_dec.addIncludePath("c/include");

    brotli_dec.linkLibC();
    b.installArtifact(brotli_dec);

    const brotli_cli = b.addExecutable(.{ .name = "brotli", .target = target, .optimize = optimize, .root_source_file = .{ .path = "c/tools/brotli.c" } });

    brotli_cli.addIncludePath("c/include");

    brotli_cli.linkLibrary(brotli_dec);
    brotli_cli.linkLibrary(brotli_encoder);
    brotli_cli.linkLibrary(brotli_common);

    brotli_cli.linkLibC();
    _ = b.addInstallArtifact(brotli_cli);
}

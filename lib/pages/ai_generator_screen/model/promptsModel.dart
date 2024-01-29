class InspirationInfo {
  final String image;
  final String prompt;

  InspirationInfo({
    required this.image,
    required this.prompt,
  });

  factory InspirationInfo.fromJson(Map<String, dynamic> json) {
    return InspirationInfo(
      image: json['images'][0]['image'],
      prompt: json['generation_info']['prompt'],
    );
  }
}

class PaginationInfo {
  final String? next;
  final String? previous;
  final int totalData;
  final int page;
  final int totalPages;
  final int pageSize;

  PaginationInfo({
    this.next,
    this.previous,
    required this.totalData,
    required this.page,
    required this.totalPages,
    required this.pageSize,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      next: json['next'],
      previous: json['previous'],
      totalData: json['total_data'],
      page: json['page'],
      totalPages: json['total_pages'],
      pageSize: json['page_size'],
    );
  }
}

class InspirationData {
  final int id;
  final List<ImageInfo> images;
  final GenerationInfo generationInfo;
  final String aspectRatio;
  final bool isActive;
  final String createdAt;
  final dynamic user;
  final dynamic generatedBy;

  InspirationData({
    required this.id,
    required this.images,
    required this.generationInfo,
    required this.aspectRatio,
    required this.isActive,
    required this.createdAt,
    required this.user,
    required this.generatedBy,
  });

  factory InspirationData.fromJson(Map<String, dynamic> json) {
    return InspirationData(
      id: json['id'],
      images: List<ImageInfo>.from(
          json['images'].map((image) => ImageInfo.fromJson(image))),
      generationInfo: GenerationInfo.fromJson(json['generation_info']),
      aspectRatio: json['aspect_ratio'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      user: json['user'],
      generatedBy: json['generated_by'],
    );
  }
}

class ImageInfo {
  final String image;
  final String watermark;
  final bool isNsfw;
  final double createdAt;

  ImageInfo({
    required this.image,
    required this.watermark,
    required this.isNsfw,
    required this.createdAt,
  });

  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      image: json['image'],
      watermark: json['watermark'],
      isNsfw: json['is_nsfw'],
      createdAt: json['created_at'],
    );
  }
}

class GenerationInfo {
  final int seed;
  final int steps;
  final int width;
  final int height;
  final String prompt;
  final List<String> styles;
  final List<int> allSeeds;
  final double cfgScale;
  final String samplerName;
  final String samplerIndex;
  final String negativePrompt;

  GenerationInfo({
    required this.seed,
    required this.steps,
    required this.width,
    required this.height,
    required this.prompt,
    required this.styles,
    required this.allSeeds,
    required this.cfgScale,
    required this.samplerName,
    required this.samplerIndex,
    required this.negativePrompt,
  });

  factory GenerationInfo.fromJson(Map<String, dynamic> json) {
    return GenerationInfo(
      seed: json['seed'],
      steps: json['steps'],
      width: json['width'],
      height: json['height'],
      prompt: json['prompt'],
      styles: List<String>.from(json['styles']),
      allSeeds: List<int>.from(json['all_seeds']),
      cfgScale: json['cfg_scale'],
      samplerName: json['sampler_name'],
      samplerIndex: json['sampler_index'],
      negativePrompt: json['negative_prompt'],
    );
  }
}

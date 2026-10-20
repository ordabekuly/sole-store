from pathlib import Path
from PIL import Image
frames = sorted(Path('build/lab7_frames').glob('*.png'))
images = [Image.open(p).convert('RGB') for p in frames]
images[0].save('docs/lab7-navigation.gif', save_all=True, append_images=images[1:], duration=80, loop=0, optimize=True)
try:
    import imageio_ffmpeg, subprocess
    subprocess.run([imageio_ffmpeg.get_ffmpeg_exe(), '-y', '-framerate', '12.5', '-i', 'build/lab7_frames/%04d.png', '-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-movflags', '+faststart', 'docs/lab7-navigation.mp4'], check=True)
except ImportError:
    print('MP4 encoder unavailable; GIF was saved.')
print('Frames:', len(frames), 'Duration:', len(frames)*.08)

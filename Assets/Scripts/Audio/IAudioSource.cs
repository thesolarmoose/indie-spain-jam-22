namespace Audio
{
    public interface IAudioSource
    {
        float Volume { get; set; }
        void Play();
        void Stop();
    }
}
using UnityEngine;

namespace Audio
{
    public class DefaultAudioSource : MonoBehaviour, IAudioSource
    {
        [SerializeField] private AudioSource _source;

        public float Volume
        {
            get => _source.volume;
            set => _source.volume = value;
        }
        
        public void Play()
        {
            _source.Play();
        }

        public void Stop()
        {
            _source.Stop();
        }
    }
}
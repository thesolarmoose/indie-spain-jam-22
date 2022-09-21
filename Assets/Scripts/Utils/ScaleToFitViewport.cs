using System;
using UnityEngine;
using Utils.Attributes;

namespace Utils
{
    public class ScaleToFitViewport : MonoBehaviour
    {
        [SerializeField, AutoProperty(AutoPropertyMode.Scene)]
        private Camera _camera;

        [SerializeField] private float _widthScale;

        private void Start()
        {
            Fit();
        }

        private void Fit()
        {
            float height = _camera.orthographicSize * 2;
            float width = _camera.aspect * height * _widthScale;
            
            var scale = new Vector3(width, height, 1);
            transform.localScale = scale;
        }
    }
}